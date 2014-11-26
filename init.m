% init.m
%
%   - detection of space-time interest points on two example image sequences
%   - construction of k-means visual dictionary
%   - assignment of feature labels according to the visual dictionary
%


babypath='./baby_expressions/';
stippath='./stip/data';
datapath='data';

%%%%%%%%%%
%%%%%%%%%% bin\stipdet.exe -f data\walk-simple.avi -o data\walk-simple-stip.txt
%%%%%%%%%% bin\stipdet.exe -f data\walk-complex.avi -o data\walk-complex-stip.txt
%%%%%%%%%%
%%%%%%%%%% 'stipdet' code is also available from 
%%%%%%%%%% http://www.irisa.fr/vista/Equipe/People/Laptev/download.html#stip
addpath('./stip/data');


%skip if not a demo
if 0 % read image sequences
  if 1
    % from avi videos 
    f1= read_video([stippath '/1114_baby_smile.avi'],'avi');
    
    
    
    %f1= read_video([stippath '/walk-simple.avi'],'avi');
    %read_image_sequence([stippath '/walk-simple.avi'],'',1,110,0,1);
    %f2= read_video([stippath '/walk-complex.avi'],'avi');
    %read_image_sequence([stippath '/walk-complex.avi'],'',1,100,0,1);
    %save([datapath '/samplevids.mat'],'f1','f2');
  else
    % from pre-saved matlab file
    load([datapath '/samplevids.mat'],'f1','f2');
  end
  
  % display videos
  set(gcf, 'name', 'Raw video sequence')
  fprintf('Displaying the first sequence...\n')
  show_xyt(f1)
  %fprintf('Displaying the second sequence...\n')
  %show_xyt(f2)
  fprintf('Press a key...\n\n'), pause
end




if 0 % load and display features
  
  %[pos1,val1,dscr1]=readstips_text([babypath '/neg_neut_pos.txt']);
  
  %[pos1,val1,dscr1]=readstips_text([stippath '/walk-simple-stip.txt']);
  %fprintf('Displaying features from the first sequence...\n')
  %showcirclefeatures_xyt(f1,pos1);
  %fprintf('Displaying features from the second sequence...\n')
  %showcirclefeatures_xyt(f2,pos2);
  
  fprintf('Initialized the visual words...\n');
  fprintf('Press a key...\n\n'), pause
  fprintf('loading\n\n')
end

if 0 % k-means clustering of descriptors
  
  % k-means clustering of descriptors 'dscr1' obtained for the of the first sequence
  
  [pos1,val1,dscr1]=readstips_text([babypath '/neg_neut_pos.txt']);
  disp('Stips loaded....');
  [centers1,labels1,mimdist1]=kmeans(dscr1,400);
  disp('Clustering completed...');
  % visualization of features belonging to the two largest clusters
  %ind1=find(labels1<=2);
  %fprintf('Displaying feature clusters for the first (training) sequence...\n')
  %showcirclefeatures_xyt(f1,pos1(ind1,:),labels1(ind1));
end

if 1 
    for i=1:7
        load('./baby_stips/baby_vocab.mat');
        stipname = './baby_stips/training';
        name = [stipname,num2str(i), '.txt'];
        disp(['reading stips: ',name])
        [pos2,val2,dscr2]=readstips_text(name);
        dmat = eucliddist(dscr2,centers1);
        [bins, labels2] = min(dmat,[],2);

        vidnum=i;

        if(i<4)
            vidname = [babypath 'negative'];
        elseif(i<11)
            vidnum=i-3;
            vidname = [babypath 'neutral'];
        else
            vidnum=i-10;
            vidname = [babypath 'positive'];
        end
        
        f2= read_video([vidname, num2str(vidnum), '.avi'],'avi');
        ind2=find(labels2<=40);
        disp(['Displaying feature clusters for sequence: ', num2str(i) ,'...\n']);
        
        %savefilename = ['./baby_stips/histograms/','testhist',num2str(i),'.mat'];
        %save(savefilename,'labels2');
        %disp(['Saved...',savefilename]);
        
        showcirclefeatures_xyt(f2,pos2(ind2,:),labels2(ind2));
    end
end

if 0  % assign points to cluster centers
  
  % labels for features in the second sequence

  [pos2,val2,dscr2]=readstips_text('./baby_stips/training2.txt');
  dmat = eucliddist(dscr2,centers1);
  [bins, labels2] = min(dmat,[],2);
  f2= read_video([babypath '/negative2.avi'],'avi');
  ind2=find(labels2<=2);
  fprintf('Displaying feature clusters for the second (test) sequence...\n')
  showcirclefeatures_xyt(f2,pos2(ind2,:),labels2(ind2));
end
