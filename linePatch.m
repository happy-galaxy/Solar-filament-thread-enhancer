function patch = linePatch(lines,imgWin)%#codegen

nRows=size(lines,1);
nPoints=size(lines,2);
patch=zeros(nRows/2,nPoints);
r=1;
for i=1:2:nRows
    for j=1:nPoints
        patch(r,j)=imgWin(lines(i+1,j),lines(i,j));
    end
    r=r+1;
end

