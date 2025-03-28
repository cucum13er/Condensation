% generate condenstation figures dataset
clear;clc;close all;
save_folder = "./dataset/training/";
std =0.06; % get from real-world substrate data
class = ["line","sin"];
radius = [4,2; 5,3; 6,4; 7,5;...
          4,3; 5,4; 6,5; 7,6;...
          5,2; 6,3; 7,4;];
sinF = {1:3;1:5;1:7;1:10;1:20};
sinA = 20 ./ cellfun('length',sinF);
number = [1500,1000;1500,1500;1500,2000;...
          2000,1000;2000,1500;2000,2000;2000,2500;...
          2500,1500;2500,2000;2500,2500;];
reflection = [true,false];
small_width = [50,60,70,80,90,100];
big_width = 100;
parfor i = 1:10 % 10 images each kind
    for j = 1:2 % classes
        if j == 1 % lines
            for k = 1:size(radius,1) % radius combination
                for l = 1:size(number,1) % different density
                    for m = 1:length(small_width) % different small line width
                        for n = 1:2 % reflection or not

                            mask_name = sprintf("MASK%02d_%s_Radius%d_%d_Density%d_%d_Width%d_Reflection_%d.tif",...
                                                i,class(j),radius(k,1),radius(k,2),number(l,1),number(l,2),small_width(m),reflection(n));
                            img_name = sprintf("IMG%02d_%s_Radius%d_%d_Density%d_%d_Width%d_Reflection_%d.tif",...
                                               i,class(j),radius(k,1),radius(k,2),number(l,1),number(l,2),small_width(m),reflection(n));
                            [img, mask] = gen_condensation(std, ...
                                                           class(j),...
                                                           small_width(m),...
                                                           big_width,...
                                                           sinF,...
                                                           sinA,...
                                                           radius(k,:),...
                                                           number(l,:),...
                                                           reflection(n));   
                            if ~isempty(img)
                                imwrite(mask, fullfile(save_folder,mask_name));
                                imwrite(img,fullfile(save_folder,img_name));
                            end
                        end
                    end
                end
            end
        
        else % curves            
            for s = 1:size(sinF,1) % different curves
                for k = 1:size(radius,1) % radius combination
                    for l = 1:size(number,1) % different density
                        for m = 1:length(small_width) % different small line width
                            for n = 1:2 % reflection or not
                                mask_name = sprintf("MASK%02d_%s_Radius%d_%d_Density%d_%d_Width%d_Reflection_%d_Curve%dto%d.tif",...
                                                    i,class(j),radius(k,1),radius(k,2),number(l,1),number(l,2),small_width(m),reflection(n),sinF{s}(1),sinF{s}(end));
                                img_name = sprintf("IMG%02d_%s_Radius%d_%d_Density%d_%d_Width%d_Reflection_%d_Curve%dto%d.tif",...
                                                   i,class(j),radius(k,1),radius(k,2),number(l,1),number(l,2),small_width(m),reflection(n),sinF{s}(1),sinF{s}(end));
                                [img, mask] = gen_condensation(std,...
                                                               class(j),...
                                                               small_width(m),...
                                                               big_width,...
                                                               sinF{s},...
                                                               sinA(s),...
                                                               radius(k,:),...
                                                               number(l,:),...
                                                               reflection(n));
                                if ~isempty(img)
                                    imwrite(mask, fullfile(save_folder,mask_name));
                                    imwrite(img,fullfile(save_folder,img_name));
                                end
                            end
                        end
                    end
                end
            end

        end
    end
end
            
%% loop starts
function [img, mask] = gen_condensation(std,class,small_width,big_width,sinF,sinA,radius,number,reflection)
    
    img = zeros(1000,1000,1) + 0.1 + 0.5*rand;
    img = imnoise(img,'gaussian',0,std^2);
    mask_size = size(img);
    mask = gen_mask(mask_size, class, small_width, big_width, sinF, sinA, "");
    img = gen_droplets_region(img, mask, radius, number, reflection);
    if ~isempty(img)
        img = 1 - img;
    end
    
end