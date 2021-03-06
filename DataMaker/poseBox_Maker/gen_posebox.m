% generate posebox from a given folder
% input: image directory
% input: pose estimation result
% output: posebox of all the images in the directory
img_dir = '/data/data/Market-1501-v15.09.15/bounding_box_train/';
img_files = dir([img_dir '*.jpg']);
[NUM,TXT,RAW]=xlsread('/home/huangyj/pre/PoseBox-Reid/DataMaker/re-id_pose.xls');
img_name = TXT(2:end, 1);
pose = (NUM+1);
clear NUM TXT RAW
write_dir = '/data/data/Market-1501-v15.09.15/';
mkdir(write_dir);

for n = 1:length(img_name)
    n
    img = imread([img_dir img_name{n}]);
    img = imresize(img, 2.8750);

    head = [pose(n, 1), pose(n, 2)];
    neck = [pose(n, 4), pose(n, 5)];
    d = sqrt(sum((head-neck).*(head-neck)));
    pthead = calheadneck(head, neck, ceil(d/3*2));
    
    shouder1 = [pose(n, 7), pose(n, 8)];
    shouder2 = [pose(n, 16), pose(n, 17)];
    [shoulderL, shoulderDrawL, shoulderR, shoulderDrawR] = calDraw(shouder1, shouder2, [-5, -5], [5, -5]);

    hip1 = [pose(n, 25), pose(n, 26)];
    hip2 = [pose(n, 34), pose(n, 35)];
    [hipL, hipDrawL, hipR, hipDrawR] = calDraw(hip1, hip2, [-10, 10], [10, 0]);

    confidence = pose(n, 9)+pose(n, 18)+pose(n, 27)+pose(n, 36)-4;
    
    knee1 = pose(n, 28:29);
    knee2 = pose(n, 37:38);
    if knee1(1) < knee2(1)
        kneeL = knee1;
        kneeR = knee2;
    else
        kneeL = knee2;
        kneeR = knee1;
    end
    if confidence < 0.8
        kneeL = kneeL - ceil(rand(1, 2).*4);
        kneeR = kneeR - ceil(rand(1, 2).*4);
        hipL = hipL + ceil(rand(1, 2).*4);
        hipR = hipR + ceil(rand(1, 2).*4);
    end
    ptL = calRectKnee(kneeL, hipL, 15);
    ptR = calRectKnee(kneeR, hipR, 15);
    feet1 = pose(n, 31:32);
    feet2 = pose(n, 40:41);
    if feet1(1) < feet2(1)
        feetL = feet1;
        feetR = feet2;
    else
        feetL = feet2;
        feetR = feet1;
    end
    ptFeetL = calRectKnee(feetL, kneeL, 15);
    ptFeetR = calRectKnee(feetR, kneeR, 15);

    elbow1 = pose(n, 10:11);
    elbow2 = pose(n, 19:20);
    if elbow1(1) < elbow2(1)
        elbowL = elbow1;
        elbowR = elbow2;
    else
        elbowL = elbow2;
        elbowR = elbow1;
    end
    if confidence < 0.8
        elbowL = elbowL - ceil(rand(1, 2).*4);
        elbowR = elbowR - ceil(rand(1, 2).*4);
    end
    ptelbowL = calRectKnee(elbowL, shoulderL, 10);
    ptelbowR = calRectKnee(elbowR, shoulderR, 10);
    
    wrist1 = pose(n, 13:14);
    wrist2 = pose(n, 22:23);
    if wrist1(1) < wrist2(1)
        wristL = wrist1;
        wristR = wrist2;
    else
        wristL = wrist2;
        wristR = wrist1;
    end
    ptwristL = calRectKnee(wristL, elbowL, 10);
    ptwristR = calRectKnee(wristR, elbowR, 10);
    img = double(img)./255;
    
    headH = 0;
        
%     w = headH; h = headH;
%     p1 = [pthead{1}(1), pthead{1}(2); pthead{2}(1), pthead{2}(2);...
%         pthead{3}(1), pthead{3}(2); pthead{4}(1), pthead{4}(2)];
%     p2 = [1, 1; w, 1; w, h; 1, h];
%     subimg0 = projection(p1, p2, img, w, h);
    w = 40; h = 56;
    p1 = [ptelbowL{1}(1), ptelbowL{1}(2); ptelbowL{2}(1), ptelbowL{2}(2);...
        ptelbowL{4}(1), ptelbowL{4}(2); ptelbowL{3}(1), ptelbowL{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg6 = projection(p1, p2, img, w, h);
    
    w = 40; h = 56;
    p1 = [ptelbowR{1}(1), ptelbowR{1}(2); ptelbowR{2}(1), ptelbowR{2}(2);...
        ptelbowR{4}(1), ptelbowR{4}(2); ptelbowR{3}(1), ptelbowR{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg7 = projection(p1, p2, img, w, h);

    w = 40; h = 56;
    p1 = [ptwristL{1}(1), ptwristL{1}(2); ptwristL{2}(1), ptwristL{2}(2);...
        ptwristL{4}(1), ptwristL{4}(2); ptwristL{3}(1), ptwristL{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg8 = projection(p1, p2, img, w, h);
    
    w = 40; h = 56;
    p1 = [ptwristR{1}(1), ptwristR{1}(2); ptwristR{2}(1), ptwristR{2}(2);...
        ptwristR{4}(1), ptwristR{4}(2); ptwristR{3}(1), ptwristR{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg9 = projection(p1, p2, img, w, h);
    
    w = 144; h = 112;
    p1 = [shoulderDrawL(1), shoulderDrawL(2); shoulderDrawR(1), shoulderDrawR(2);...
        hipDrawR(1), hipDrawR(2); hipDrawL(1), hipDrawL(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg1 = projection(p1, p2, img, w, h);
    
    w = 112; h = 56;
    p1 = [ptL{1}(1), ptL{1}(2); ptL{2}(1), ptL{2}(2);...
        ptL{4}(1), ptL{4}(2); ptL{3}(1), ptL{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg2 = projection(p1, p2, img, w, h);

    w = 112; h = 56;
    p1 = [ptR{1}(1), ptR{1}(2); ptR{2}(1), ptR{2}(2);...
        ptR{4}(1), ptR{4}(2); ptR{3}(1), ptR{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg3 = projection(p1, p2, img, w, h);
    
    w = 112; h = 56;
    p1 = [ptFeetL{1}(1), ptFeetL{1}(2); ptFeetL{2}(1), ptFeetL{2}(2);...
        ptFeetL{4}(1), ptFeetL{4}(2); ptFeetL{3}(1), ptFeetL{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg4 = projection(p1, p2, img, w, h);    

    w = 112; h = 56;
    p1 = [ptFeetR{1}(1), ptFeetR{1}(2); ptFeetR{2}(1), ptFeetR{2}(2);...
        ptFeetR{4}(1), ptFeetR{4}(2); ptFeetR{3}(1), ptFeetR{3}(2)];
    p2 = [1, 1; w, 1; w, h; 1, h];
    subimg5 = projection(p1, p2, img, w, h);    
    
    posebox = zeros(224, 224, 3);
%     brick_img(1:headH, 112-headH/2:112+headH/2-1, :) = subimg0;
    posebox(1:112, 41:41+143, :) = subimg1;
    posebox(113:113+56-1, 1:112, :) = subimg2;
    posebox(113:113+56-1, 113:224, :) = subimg3;
    posebox(113+56:end, 1:112, :) = subimg4;
    posebox(113+56:end, 113:224, :) = subimg5;
    posebox(1:56, 1:40, :) = subimg6;
    posebox(57:112, 1:40, :) = subimg8;
    posebox(1:56, end-40+1:end, :) = subimg7;
    posebox(57:112, end-40+1:end, :) = subimg9;
    
    write_path = [write_dir img_name{n}];
    imwrite(posebox, write_path);
    
    %%%%%%% uncomment the following codes will visualize the posebox %%%%%%%%%%
%     imshow(img);
%     hold on;
%     for k = 1:14
%         plot(pose(n, (k-1)*3+1), pose(n, (k-1)*3+2), 'Marker', 'x', 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g', 'MarkerSize', 8);
%         hold on;
%     end    
% 
%     line([shoulderDrawL(1), shoulderDrawR(1)], [shoulderDrawL(2), shoulderDrawR(2)], 'Color', 'g');
%     line([hipDrawL(1), hipDrawR(1)], [hipDrawL(2), hipDrawR(2)], 'Color', 'g');
%     line([shoulderDrawL(1), hipDrawL(1)], [shoulderDrawL(2), hipDrawL(2)], 'Color', 'g');
%     line([shoulderDrawR(1), hipDrawR(1)], [shoulderDrawR(2), hipDrawR(2)], 'Color', 'g');   
% 
%     drawRect(pthead);
%     drawRect(ptL);
%     drawRect(ptR);
% 
%     drawRect(ptFeetL);
%     drawRect(ptFeetR);    
%     
% 
%     drawRect(ptelbowL);
%     drawRect(ptelbowR);
% 
%     drawRect(ptwristL);
%     drawRect(ptwristR);
%     figure;
%     imshow(posebox);
%     close all;
end
