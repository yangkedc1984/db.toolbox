function th=rotateticklabel0(h,rot,SC)
% ROTATETICKLABEL rotates tick labels
%   TH=ROTATETICKLABEL(H,ROT) is the calling form where H is a handle to
%   the axis that contains the XTickLabels that are to be rotated. ROT is
%   an optional parameter that specifies the angle of rotation. The default
%   angle is 90. TH is a handle to the text objects created. For long
%   strings such as those produced by datetick, you may have to adjust the
%   position of the axes so the labels don't get cut off.
% 		
% 		INPUTS:		h		= figure handle
% 							rot = rotation factor, ie 90, or 45 etc.
% 							SC  = scale factor for the placement below the X axis labels.
% 
%   Of course, GCA can be substituted for H if desired.
% 
%   Known deficiencies: if tick labels are raised to a power, the power
%   will be lost after rotation.
% 
%   See also datetick.
%   Written Oct 14, 2005 by Andy Bliss
%   Copyright 2005 by Andy Bliss
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Modified by Daniel Buncic 2014.
% % %DEMO:
% % if nargin==3
% %     x=[now-.7 now-.3 now];
% %     y=[20 35 15];
% %     figure
% %     plot(x,y,'.-')
% %     datetick('x',0,'keepticks')
% %     h=gca;
% %     set(h,'position',[0.13 0.35 0.775 0.55])
% %     rot=90;
% % end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

SetDefaultValue(3,'SC'       , 0.2);

%set the default rotation if user doesn't specify
if nargin==1
    rot=90;
end
%make sure the rotation is in the range 0:360 (brute force method)
while rot>360
    rot=rot-360;
end
while rot<0
    rot=rot+360;
end
%get current tick labels
a=get(h,'XTickLabel');
% get the font size
FS = get(h,'FontSize');
%erase current tick labels from figure
set(h,'XTickLabel',[]);
%get tick label positions
b=get(h,'XTick');
c=get(h,'YTick')
%make new tick labels

%%SC = .2

repmat(c(1)-SC*(c(2)-c(1)),length(b),1)

if rot<180
    th=text(b,repmat(c(1)-SC*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','right','rotation',rot);
else
    th=text(b,repmat(c(1)-SC*(c(2)-c(1)),length(b),1),a,'HorizontalAlignment','right','rotation',rot);
end
set(th,'FontSize',FS)
