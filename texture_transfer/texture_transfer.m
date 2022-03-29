function out = texture_transfer(sample, target, blockSize, errorTolerance, iterationNum)
    sample=im2double(sample);
    target=im2double(target);
    overlapWidth=floor(blockSize/6);
    [M,N,K]=size(target);

    out=zeros([M N K]);

    for k=1:iterationNum
        alpha=0.8*(k-1)/(iterationNum-1)+0.1;
        %% for each block
        for i=1:blockSize-overlapWidth:M
            for j=1:blockSize-overlapWidth:N       
                if i==1 && j==1
                    matchPos=find_match(sample,target,out,[i j],blockSize,errorTolerance,alpha,1);
                    out(1:blockSize,1:blockSize,:)=sample(matchPos(1):matchPos+blockSize-1,matchPos(2):matchPos(2)+blockSize-1,:);
                else
                    curPos=[ i j ];
                    if i>M-blockSize+1
                        curPos(1)=M-blockSize+1;
                    end
                    if j>N-blockSize+1
                        curPos(2)=N-blockSize+1;
                    end

                    matchPos=find_match(sample,target,out,curPos,blockSize,errorTolerance,alpha,0);
                    out=overlap_quilting(sample,blockSize,overlapWidth,out,curPos,matchPos);
                end
            end
        end
        blockSize=blockSize/3;
    end
end