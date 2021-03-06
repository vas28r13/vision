function [pos,val,dscr]=readstips_text(stipfname)

% [pos,val,dscr]=readstips_text(stipfname)
%

  
l=readlines(stipfname);

if 1 % length(regexpi(l{1},'STIP-format-1.0','match'))
  %width=regexp(regexp(l{2},'width:\d+','match'),'\d+','match');
  %if length(width) width=str2num(width{1}{1}); else width=0; end
  %height=regexp(regexp(l{2},'height:\d+','match'),'\d+','match');
  %if length(height) height=str2num(height{1}{1}); else height=0; end
  %offset=regexp(regexp(l{2},'frame-offset:\d+','match'),'\d+','match');
  %if length(offset) offset=str2num(offset{1}{1}); else offset=0; end
  
  ind=setdiff(1:length(l),strmatch('#',l));
  n=length(ind)-3;
  pos=zeros(n,5);
  val=zeros(n,1);
  dscr=[];
  for i=1:length(ind)
    v=transpose(sscanf(l{ind(i)},'%f'));
    if size(v)==0 
      continue;
    end
    pos(i,:)=v([5 6 7 8 9]);
    %pos(i,:)=v(2:6);
    %pos(i,3)=v(4)-offset;
    %pos(i,1)=height-pos(i,1);
    val(i)=v(9);
    if length(v)>9
      dscr(i,:)=v(10:end);
    end
  end
end
