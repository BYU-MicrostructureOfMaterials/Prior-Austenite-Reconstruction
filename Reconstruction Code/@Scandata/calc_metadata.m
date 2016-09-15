function [] = calc_metadata(obj)

% X = [obj.pointdata.x];
% Y = [obj.pointdata.y];

X = obj.pointdata.x;
Y = obj.pointdata.y;

%Extract stepsize, account for possible holes and irregularities in scan data
xvals = round(sort(unique(X(:))),2);
xshift = circshift(xvals,1);
xstep = round(min(abs(xvals-xshift)),2);     %ROUNDING NOT WORKING. NEED TO SHIFT TO INTEGER MATH
xcheck = setdiff(xvals,round(min(xvals):xstep:max(xvals),2));
if any(xcheck), error('X spacing of scanpoints is irregular'); end

yvals = round(sort(unique(Y(:))),2);
yshift = circshift(yvals,1);
ystep = round(min(abs(yvals-yshift)),2);
ycheck = setdiff(yvals,round(min(yvals):ystep:max(yvals),2));
if any(ycheck), error('Y spacing of scanpoints is irregular'); end

%check square scan
if ystep~=xstep, error('Stepsize not square!'); end
obj.stepsize = xstep;

obj.numScanpoints = length(X);
obj.numGrains = length(obj.graindata.avgphi1);

obj.minx = min(X);
obj.maxx = max(X);
obj.miny = min(Y);
obj.maxy = max(Y);

obj.datalocked = true;

end