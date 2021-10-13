clear
clc
close all
%%Read the file
files=dir('./attachment/*.bmp');
number=numel(files);
image=cell(1,number);
for n=1:number
    image{n}=imread(['./attachment/',files(n).name]);
end

%%Image Binarization
for i=1:19
    image{i}=imbinarize(image{i});
end

%%Solve the similar matrix
xs=zeros(number,number);         %Initialize the similar matrix
[rows,cols]=size(image{1});     %Find the number of rows and columns
count=zeros(2,number);          %Use the page margins to find the first and the last picture
for i=1:number
    %Count from the far left
    count(1,i)=sum(image{i}(:,1)==1);
    %Count from the far right
    count(2,i)=sum(image{i}(:,cols)==1);
    for j=1:number
        %Comparison of the far right side of the i-th paper and the far left side of the j-th paper
        if i~=j
            xs(i,j)=sum(image{i}(:,cols)==image{j}(:,1));
        end
    end
    
end

%%According to the similarity matrix, find the most matching piece of paper
suit=zeros(number,2);       %Put the results into suit
suit(:,1)=1:number;
[xs_max,suit(:,2)]=max(xs,[],2);

%%Find the picture of the edge
[x1,left]=max(count(1,:));
[x2,right]=max(count(2,:));

%%Get the result of sort
result=zeros(number,1);
result(1)=left;
for i=2:number
    result(i)=suit(result(i-1),2);
end

%%Output the stitched image
I=zeros(rows,cols*number);
for i=1:number
    I(:,1+(i-1)*cols:i*cols)= image{result(i)};
end
imwrite(I,'res1.jpg','quality',100);
imshow('res1.jpg')                
