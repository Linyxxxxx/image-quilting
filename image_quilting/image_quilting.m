function out = image_quilting(sample, blockSize, magnification, errorTolerance)
    %% parameters
    sample=im2double(sample);
    overlapWidth=floor(blockSize/6);
    outSize=(blockSize-overlapWidth)*(magnification-1)+blockSize;
    
    out=zeros([outSize outSize 3]);
    [M,N,~]=size(sample);
    
    %% for each block
    for i=1:blockSize-overlapWidth:(magnification-1)*(blockSize-overlapWidth)+1
        for j=1:blockSize-overlapWidth:(magnification-1)*(blockSize-overlapWidth)+1
            % first one: set in random
            if i==1 && j==1
                posX=min(ceil(M*rand),M-blockSize+1);
                posY=min(ceil(N*rand),N-blockSize+1);
                out(1:blockSize,1:blockSize,:)=sample(posX:posX+blockSize-1,posY:posY+blockSize-1,:);
            else
                curPos=[ i j ];
                % find closest block according to overlap
                blockPos=find_block(sample,blockSize,overlapWidth,out,curPos,errorTolerance);
                % set block
                out=overlap_quilting(sample,blockSize,overlapWidth,out,curPos,blockPos);
            end
        end
    end
end