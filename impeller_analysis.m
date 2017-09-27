clc; clear all; close all;

Rotor = [];
AirGapRatios = [];
for k = [2 3 5 6 7 9 10]
    
    img1 = imread(['impellers/rotor',sprintf('%2.2d',k),'.jpg']);
    
    Ihsv = rgb2hsv(img1);
    I = Ihsv(:,:,3);
    
    BW = edge(I,'Canny',0.3);
    
    SE1 = strel('line',4,0);
    SE2 = strel('line',4,90);
    BW = imdilate(BW,[SE1 SE2]);
    
    BWfill = imfill(BW,'holes');
   
    [labels,number] = bwlabel(BW,8);
    Istats =regionprops(labels,'basic','Centroid');
    [maxVal, maxIndex] = max([Istats.Area]);
    Istats(maxIndex).BoundingBox;
    
    x = Istats(maxIndex).BoundingBox(1);
    y = Istats(maxIndex).BoundingBox(2);
    w = Istats(maxIndex).BoundingBox(3);
    h = Istats(maxIndex).BoundingBox(4);
    
    CentX = x+w/2;
    CentY = y+h/2;
    
    X = 0:(sqrt(numel(BWfill))-1);
   
    r = max(w,h)/2;
    cir = bsxfun(@(CentX,CentY) CentX.^2+CentY.^2<r^2,X-CentX,X'-CentY);
    sumInt = sum(cir);
    totalPix = sum(sumInt);
    
    airImg = cir - BWfill;
    sumInt = sum(airImg);
    gapPix = sum(sumInt);
 
    gapRat = gapPix/totalPix;
    
    Rotor = [Rotor; k];
    AirGapRatios = [AirGapRatios; gapRat];
   
end
tab = table(Rotor,AirGapRatios);
disp(tab)