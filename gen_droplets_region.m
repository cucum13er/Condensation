% This function generates the simulated condensation droplets based on the
% given mask.
% inputs: 
%   image: img [row,col,1] double
%   mask: [row,col,1] double, contain 0s and 1s, 0 represents small 
% droplets, 1 represents big droplets
%   radius: [10, 5] mean radius of both big and small droplets
%   number: [2000, 2000] how many droplets will be generated in total for 
% big and small droplets
%   reflection: false/true, indicates wether to include reflection in the
% droplet centers
function img = gen_droplets_region(img, region_mask, radius, number, reflection)
if (nargin < 4)
    number = [1000,1000];
end
if (nargin < 5)
    reflection = false; 
end
img = double(img);
img_origin = img;
region_mask = double(region_mask);
% insert big droplets for the big region
for i = 1:number(1)
    radius_cand = normrnd(radius(1),1);
    radius_check = ceil(radius_cand);
    center = [randi(size(img,1)), randi(size(img,2))];
    while region_mask(center(1),center(2),1) ~= 1
        center = [randi(size(img,1)), randi(size(img,2))];
    end
    
    patch_cand = img( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                 max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :); 
    patch_origin = img_origin( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                 max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :); 
    cnt=0;
%     maxcnt = 0;
    while ~isequal(patch_cand, patch_origin)
        center = [randi(size(img,1)), randi(size(img,2))];
        while region_mask(center(1),center(2),1) ~= 1
            center = [randi(size(img,1)), randi(size(img,2))];
        end        
        patch_cand = img( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                     max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :); 
        patch_origin = img_origin( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                     max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :);         
        cnt = cnt+1;
        if cnt>200
            img = [];
            return;
        end
    end
%     if cnt>maxcnt
%         maxcnt = cnt;
%     end
    img = insertShape(img,"filled-circle",[center(2),center(1),radius_cand],"Color","white");
    if reflection
        move_range = -round(radius_cand/4):round(radius_cand/4);
        if length(move_range) <= 1
            img = insertShape(img,"filled-circle",[center(2),center(1),radius_cand/(3+rand)],"Color","black");
        else
            img = insertShape(img,"filled-circle",[center(2)+randsample(move_range,1),center(1)+randsample(move_range,1),radius_cand/(3+rand)],"Color","black");
        end
    end
    img = img(:,:,1);
%     imshow(img)
end

% insert small droplets for the small region
for i = 1:number(2)
    radius_cand = normrnd(radius(2),1);
    radius_check = ceil(radius_cand);
    center = [randi(size(img,1)), randi(size(img,2))];
    while region_mask(center(1),center(2),1) ~= 0
        center = [randi(size(img,1)), randi(size(img,2))];
    end

    patch_cand = img( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                 max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :); 
    patch_origin = img_origin( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                 max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :); 
    cnt=0;
    while ~isequal(patch_cand, patch_origin)
        center = [randi(size(img,1)), randi(size(img,2))];
        while region_mask(center(1),center(2),1) ~= 0
            center = [randi(size(img,1)), randi(size(img,2))];
        end        
        patch_cand = img( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                     max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :);  
        patch_origin = img_origin( max(1,center(1)-radius_check):min(center(1)+radius_check,size(img,1)), ...
                     max(center(2)-radius_check,1):min(center(2)+radius_check,size(img,2)), :); 
        cnt = cnt+1;
        if cnt>200
            img = [];
            return;
        end
    end
    img = insertShape(img,"filled-circle",[center(2),center(1),radius_cand],"Color","white");
    if reflection
        move_range = -round(radius_cand/4):round(radius_cand/4);
        if length(move_range) <= 1
            img = insertShape(img,"filled-circle",[center(2),center(1),radius_cand/(3+rand)],"Color","black");
        else
            img = insertShape(img,"filled-circle",[center(2)+randsample(move_range,1),center(1)+randsample(move_range,1),radius_cand/(3+rand)],"Color","black");
        end
    end
    img = img(:,:,1);    
%     imshow(img)
end
% disp(maxcnt)
end