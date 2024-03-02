close all;clear;clc;
set(0,'defaultfigurecolor','w');

plot_latency(121);

OC = 64;   OH = 224;   OW = 224;
IC = 3;    IH = 224;    IW = 224;
KH = 3;     KW =3;
POOL_OW = OH;
Stride = 1;

FPGA = "XC7A100T";
if (FPGA == "ZU15EG")
    BW = 150;        % Gbps
    Freq = 300;     % MHz
else
    BW = 25;        % Gbps
    Freq = 200;     % MHz
end
DW = 32;        % bit
DPC = BW * 1024 / (DW * Freq);

for vecLen = 1 : KW
    for N = 1:1000
        %  先看资源够不够
        [FF,LUT,DSP] = resource (vecLen,N, FPGA);
        if ((FF > 1) || (LUT > 1) || (DSP > 1) )
            break;
        end
        latency = inf;
        %   并行度分配
        for PI = 1:min(N,IC)
            PO = N / PI;
            %   只要能整除的方案
            if ((mod(N, PI) ~=0) || (PO > OC))
                continue;
            end
            

            %   再看缓存方案行不行
            [fin_line, wgt_line, find] = storage (vecLen, PI, PO, OW, IH, IW, KH, KW, POOL_OW, Stride, DPC, FPGA);  
            if (find == 0)
                continue;
            end
            
            % 最后看处理延迟
            temp_latency = vecConv(IC,OC,OH,OW,PI,PO,vecLen,KH);
            temp_latency = temp_latency + (PI * fin_line * IW) / DPC + (PI * PO * wgt_line * KW) / DPC;
            if (latency > temp_latency)
                latency = temp_latency;
                design{vecLen,N} = [latency / Freq / 1000,LUT,PI, PO,fin_line, wgt_line];
            end
        end
    end
end



function plot_latency (vecLen)
    latency = zeros(vecLen,1);
    resource = zeros(vecLen,1);
    for i = 1:vecLen
        l2 = vecMac(vecLen,i);
        [LUT, ~, ~] = deal(i .* [278+322, 136+136, 2] - [322,136,1]);
        latency(i)=l2;
        resource(i)=LUT(1);
    end

    figure();
    
    yyaxis left;
    stem(latency,'.')
    axis([0 vecLen + 2 0 vecLen + 5])

    xlabel('vecLen');
    ylabel(['Latancy of dotProduct', num2str(vecLen)])
    
    yyaxis right;
    stem(resource, '*')
    ylabel('Consumption of LUT')
    
    legend('latency', 'LUT')
end

function [latency,ii_vecMac] = vecMac(vecLen,groupLen)
    % 函数功能是计算长度为vecLen的向量如果以groupLen进行分组实现点积所需要的时钟数
    % 比如长度是32的向量，以7进行分组，那么就需要进行ceil(32/7)=5次循环，每次循环进行1组乘法和ceil(log2(7))级加法树，后续就是ii相关的问题了
    % 要注意，分组的乘加运算ii=1并不意味着vecMac的ii=1，只有当vecLen和groupLen相等时vecMac的ii才是1
    
    % 设计的算法分组乘加运算ii = 1
    ii = 1;
    % mac的延迟
    mac_latency = 1 + ceil(log2(groupLen));
    % 循环次数
    loop = ceil(vecLen./groupLen);
    
    % 若循环次数大于1，那么还需要一个时钟把之前循环的加法值累加输出
    latency = (loop -1) * ii + mac_latency + boolean(loop > 1);
    % 整体vecMac的ii就是循环次数，也就是说在循环进行的过程中不允许新的数输入
    ii_vecMac = loop;
end


function latency = vecConv(IC,OC,OH,OW,PI,PO,vecLen,KH)
    % 函数功能是计算短向量与长向量卷积所需要的延迟

    [vec_latency,ii] = vecMac(vecLen,vecLen);          %   目的是让ii = 1
    loop_num = ceil(KH / vecLen);                      %   循环次数

    latency = (ceil(IC/PI) * ceil(OC/PO) * OH * OW * KH * loop_num - 1) * ii + vec_latency + 1 + 1;
end

function design = DSE (OC, OH, OW, IC, IH, IW, KH, KW, POOL_OW, Stride, DPC, FPGA)
    for vecLen = 1 : KW
        for N = 1:1000
            latency = inf;
            %  先看资源够不够
            [FF,LUT,DSP] = resource (vecLen,N, FPGA);
            if ((FF > 1) || (LUT > 1) || (DSP > 1) )
                break;
            end

            %   并行度分配
            for PI = 1:min(N,IC)
                %   只要能整除的方案
                if (mod(N, PI) ~=0)
                    continue;
                end
                PO = N / PI;
                % if ((mod(IC, PI) ~=0) || (mod(OC, PO) ~=0))
                %     continue;
                % end

                %   再看缓存方案行不行
                [fin_line, wgt_line, find] = storage (vecLen, PI, PO, OW, IH, IW, KH, KW, POOL_OW, Stride, DPC, FPGA);  
                if (find == 0)
                    continue;
                end
                
                % 最后看处理延迟
                temp_latency = vecConv(IC,OC,OH,OW,PI,PO,vecLen,KH);
                if (latency > temp_latency)
                    latency = temp_latency;
                    design{vecLen,N} = [latency / FREQ / 1000,LUT,PI, PO,fin_line, wgt_line];
                end
            end
        end
    end
end

function [FF,LUT,DSP] = resource (vecLen,N, FPGA)
    % 默认是XC7A100T
    if (FPGA == "ZYNQ7020")
        MAX_FF = 17400; MAX_LUT = 53200; MAX_DSP = 220;
        [LUT, FF, DSP] = deal(vecLen .* [277+322, 135+135, 2] - [322,135,1]);
        LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);
        [LUT, FF, DSP] = deal(N .* [LUT+322, FF+135, DSP + 1]);
        LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);
    elseif (FPGA == "ZU15EG")
        MAX_FF = 682560; MAX_LUT = 341280; MAX_DSP = 3528;
        [LUT, FF, DSP] = deal(vecLen .* [277+279, 135+135, 3] - [279,135,2]);
        LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);
        [LUT, FF, DSP] = deal(N .* [LUT+279, FF+135, DSP + 2]);
        LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);
    else
        MAX_FF = 126800; MAX_LUT = 63400; MAX_DSP = 240; BRAM = 135;
        [LUT, FF, DSP] = deal(vecLen .* [277+322, 135+135, 2] - [322,135,1]);
        LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);
        [LUT, FF, DSP] = deal(N .* [LUT+322, FF+135, DSP + 1]);
        LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);
    end

    FF = FF + 32 * N;
    % 留一点余量
    %[LUT, FF, DSP] = deal([LUT, FF, DSP] .* [1.01,1.15,1]);
    %LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);

    % 转为占用率
    [LUT, FF, DSP] = deal([LUT, FF, DSP] ./ [MAX_LUT,MAX_FF,MAX_DSP]);
    LUT = LUT(1);   FF = FF(2);    DSP = DSP(3);
end

function [fin_line, wgt_line, find] = storage (vecLen, PI, PO, OW, IH, IW, KH, KW, POOL_OW, Stride, DPC, FPGA)
    % 目前的策略是至少先缓存PI * KH行输入特征图
    find = 0;
    for fin_line = 0:(IH - KH)
        stride_times = floor(fin_line/Stride);          %   看多读了多少个stride行
        stride_mod = mod(fin_line,Stride);              %   看看对Stride的余数是多少

        Fixed = KH * ceil (KW / vecLen) * OW;                       %   按行处理，每一行数据都会消耗ceil (KH / vecLen) * OW个时钟
        Extra = (KH - Stride) * ceil (KW / vecLen) * OW;            %   跳过Stride行之后还剩下（KH - Stride）行数据可以用于处理
        More = stride_mod * ceil (KW / vecLen) * OW;                %   再缓存fin_line行数据至少还能多出这么多个时钟出来
        Times = stride_times * Fixed;                               %   每多缓存一个Stride行的数据就能多出Fixed个时钟

        if (fin_line < Stride)                                      %   看目前缓存下来的输入特征图数据可以带来多少个处理时钟
            clocks = Fixed + Extra + More;
        else
            clocks = Fixed + More + Times;
        end

        %   再看缓存1行权重数据后至少缓存多少行就能保证一边计算一边读取数据
        for wgt_line = 0:(KH-1)
            %   就是看缓存的wgt在参与计算时能不能把剩下的wgt也读取出来，同时还能保证计算不会中断
            wgt_buffered = (wgt_line + 1) * ceil (KH / vecLen) * OW * DPC / (PI * PO * KW) + (wgt_line + 1);
            if (wgt_buffered < KH)
                continue;
            end
            
            clocks = clocks - ((KH - wgt_line - 1) * PI * PO * KW) / DPC; %   看把读权重的时间去掉后还能剩下多少个时钟

            fin_line_left = IH - KH - fin_line;                         %   输入特征图还剩下多少行没读
            while (fin_line_left > 0)
                
                % 远比实际更严重的池化时钟消耗
                pool_clock = PO * POOL_OW * stride_times / DPC;
                clocks = clocks - pool_clock;

                data_num = clocks * DPC;                                %   剩下的时钟还能读多少个数据
                buf_line = floor(data_num / (IW*PI));                   %   这么多个数据是多少个并行行
                %   如果说读的数据少于stride行，说明当前的缓存方案不行，因为我们的处理策略是看当前KH行处理的时候能不能把下个stride行数据读出来
                if (buf_line < Stride)
                    break;
                end

                % Stride - stride_mod的意思是还缺多少行凑成一个stride行，(buf_line - (Stride-stride_mod))的意思是当前缓存的行凑成一个stride行后还能剩下多少行
                stride_times = floor((buf_line - (Stride - stride_mod))/Stride) + 1;          %   看多读了多少个stride行，后面的1意味着至少有一个stride行
                stride_mod = mod(buf_line - (Stride - stride_mod),Stride);              %   看看对Stride的余数是多少
            
                fin_line_left = fin_line_left - buf_line;

                More = stride_mod * ceil (KH / vecLen) * OW;                %   又能多出多少个时钟
                Times = stride_times * Fixed; 
                clocks = Times * Fixed + More;
            end
            
            %   说明当前的缓存方案是可行的
            if (buf_line >= Stride)
                break;
            end
        end

        %   看跳出wgt_line的循环是因为真的处理完了还是因为没法处理完就跳出了
        if (buf_line < Stride)
            continue;
        else
            find = 1;
            break;
        end
    end
    fin_line = KH + fin_line;
    wgt_line = wgt_line + 1;

    % 默认是XC7A100T
    if (FPGA == "ZYNQ7020")
        MAX_BRAM = 135; 
        bram = (fin_line * PI * PI * IW +  KH * PI * PO * min(PI, PO)* KW + PO * POOL_OW * min(PI, PO)) / 1024;      % 目的是让片上BRAM多用点，这样尽可能减少DDR空闲时间
        if (bram > MAX_BRAM)
            find = 0;
        end
    elseif (FPGA == "ZU15EG")
        MAX_BRAM = 744; 
        bram = (fin_line * PI * PI * IW +  KH * PI * PO * min(PI, PO)* KW + PO * POOL_OW * min(PI, PO)) / 1024;      % 目的是让片上BRAM多用点，这样尽可能减少DDR空闲时间
        if (bram > MAX_BRAM)
            find = 0;
        end
    else
        MAX_BRAM = 135; 
        bram = (fin_line * PI * PI * IW +  KH * PI * PO * min(PI, PO)* KW + PO * POOL_OW * min(PI, PO)) / 1024;      % 目的是让片上BRAM多用点，这样尽可能减少DDR空闲时间
        if (bram > MAX_BRAM)
            find = 0;
        end
    end

end

