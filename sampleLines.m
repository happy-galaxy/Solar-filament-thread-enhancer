function [X,Y,thetas]=sampleLines(numLines,rho,varargin)
%sampleLines 计算numLines条采样线，对图像采样时，各采样线上采样点x，y坐标
%   numLines 采样线数目
%   rho      采样圆周半径，即，采样线长度为2*rho+1
%
%   返回值：
%   X    [numLines,2*rho+1]数组，采样点x坐标
%   Y    [numLines,2*rho+1]数组，采样点y坐标
%   thetas   [1,numLines]数组(一维),thetas(i)为采样线i的角度(0~pi)


% p=parseInputs(numLines,rho,varargin{:});
debug=false;

numLines=numLines+2;
numQuarterLines=floor(numLines/2);
    

% 计算0~pi/2范围内（第一象限）极坐标对应的笛卡尔坐标
theta=linspace(0,pi/2,numQuarterLines);
quarterLines=zeros(numQuarterLines*2,rho);
for i=1:rho
    [xs,ys]=pol2cart(theta,i);
    quarterLines(1:2:end,i)=xs;
    quarterLines(2:2:end,i)=ys;
end

% 分别通过第一象限坐标，构建二、三、四象限，线段坐标
lines=zeros(numQuarterLines*2*2,rho*2+1);
thetas=zeros(1,numQuarterLines*2);
% 第三、一象限线段
lines(1:numQuarterLines*2,1:rho)=-fliplr(quarterLines);%三象限xy
lines(1:numQuarterLines*2,rho+2:end)=quarterLines;%一象限xy
thetas(1:numQuarterLines)=theta;

% 第二、四象限线段
lines(numQuarterLines*2+1:2:end,1:rho)=-quarterLines(end-1:-2:1,rho:-1:1);%二象限x
lines(numQuarterLines*2+2:2:end,1:rho)=quarterLines(end:-2:2,rho:-1:1);%二象限y

lines(numQuarterLines*2+1:2:end,rho+2:end)=quarterLines(end-1:-2:1,1:rho);%四象限x
lines(numQuarterLines*2+2:2:end,rho+2:end)=-quarterLines(end:-2:2,1:rho);%四象限y

thetas(numQuarterLines+1:end)=pi-fliplr(theta);


% 删除两条重复线段（垂直、水平）
lines(numQuarterLines*2-1:numQuarterLines*2,:)=[];
thetas(numQuarterLines)=[];
lines(end-1:end,:)=[];
thetas(end)=[];

% 将坐标中的负值转化为正值
lines(1:2:end,:)=lines(1:2:end,:)+rho+1;
lines(2:2:end,:)=lines(2:2:end,:)+rho+1;
% lines=round(lines); %整数坐标

X=lines(1:2:end,:);
Y=lines(2:2:end,:);
Y=size(Y,2)+1-Y; %将坐标原点调整为何图像坐标系一致，即，y轴从1开始向下递增

if debug
    figure;
    set(gca,'ydir','reverse');
    hold on;
    grid on;
    for i=1:size(Y,1)
        plot(X(i,:),Y(i,:));
    end
    hold off;
end

%     function p=parseInputs(m_nlines,m_rho,varargin)
%         p = inputParser;
%         addRequired(p,'m_nlines',@(x) validateattributes(x,{'numeric'},{'scalar','nonnegative'}))
%         addRequired(p,'m_rho',@(x) validateattributes(x,{'numeric'},{'scalar','nonnegative'}))
%         addParameter(p,'debug',false,@(x) islogical(x));
%         parse(p,m_nlines,m_rho,varargin{:});
%     end

end



