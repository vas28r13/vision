
function dyad = annotate_frames(save_dir, dyad_num, starting_sec, starting_frame, fps, person_type, data, vid_data)

% @param  -  save_dir       : directory where you want to save the videos
% @param  -  dyad_num       : is the string identifying the dyad (number typically)
% @param  -  stating_sec    : the second number in the coding labels
% @param  -  starting_frame : the starting frame number to properly align
% @param  -  fps            : the frames per second in the video
% @param  -  person_type    : either "infant" or "stranger"
% @param  -  data           : annotation data to properly annotate the videos
% @param  -  vid_data       : full video (dyad) of the interaction (needs to be matlab object - use VideoReader)

%change the number for the right dyad number..
dyad = dyad_num;

%either 'stranger' or 'infant'
type = person_type;

% IMPORTANT: must align the frame with vhs time :)
st = starting_frame;
en = st + fps - 1;

start = starting_sec;

for j=start:150
    
    % annotation label for adult or infant...(based on data)
    if(strcmp(type,'infant'))
        x = data(j,7);
    else
        x = data(j,6);
    end
    
    x = x{1};
    x = x(~isspace(x));
    x(x == '/') = [];
    
    viddir  = [save_dir, '/', dyad, '_', type ];
    
    if(~exist(viddir, 'dir'))
        mkdir(viddir);
    end
    
    vidname = [viddir, '/', dyad, '_', type, '_', num2str(j), '_', x];
    
    aviobj = avifile(vidname,'compression','None');
    
    
    %keep quality at 100...
    aviobj.quality = 100;
    
    %aviobj = VideoWriter('./poop.avi','Uncompressed AVI');
    %open(aviobj);
    
    for i=st:en

        m = read(vid_data, i);
        
        [x y z] = size(m)
        
        if(strcmp(type,'infant'))
            m = m(11:(x-10),11:(y/2+10),:,:);
        else
            m = m(11:(x-10),(y/2+41):(y),:,:);
        end
        
        aviobj = addframe(aviobj, m);         
        
    end
    
    %Close video stream
    aviobj = close(aviobj);
    
    st = en + 1;
    en = en + fps;
    
end

%{
        %EXTRA CODE FOR VIDEO MANIPULATION
        aviobj = addframe(aviobj, m);         
        %m = squeeze(m(:,:,1,:));
        
        %infant frame size
        %m = m(30:459,30:389,:,:);
        
        %adult frame size
        %m = m(30:469,400:719,:,:);
        
        %m = m(10:469,10:309,:,:);
        %m = m(10:429,330:609,:,:);
        
        %imshow(m);
        %pause;
        
        %writeVideo(aviobj,m);
%}
