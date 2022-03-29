function blockPos = find_block(sample, blockSize, overlapWidth, out, curPos, errorTolerance)
    [M,N,K]=size(sample);
    X=curPos(1);
    Y=curPos(2);
    
    errors=zeros(M-blockSize+1,N-blockSize+1);
    
    %% calc error according to Euler-distance
    for i=1:M-blockSize+1
        for j=1:N-blockSize+1

            errorX=out(X:X+blockSize-1,Y:Y+overlapWidth-1,:)-sample(i:i+blockSize-1,j:j+overlapWidth-1,:);
            errorX=errorX.*errorX;

            errorY=out(X:X+overlapWidth-1,Y:Y+blockSize-1,:)-sample(i:i+overlapWidth-1,j:j+blockSize-1,:);
            errorY=errorY.*errorY;

            error=sum(sum(sum(errorX)))+sum(sum(sum(errorY)));
            
            if error==0
                errors(i, j)=inf;
            else
                errors(i, j)=error;
            end
        end
    end
    
    %% extend error to error-tolerance
    minErrorBlock=repmat(min(min(errors)), size(errors));
    
    [Xs, Ys]=find(minErrorBlock.*(1+errorTolerance)-errors>0);
    
    %% choose ONE block in random
    blockPos=[ Xs(randperm(size(Xs,1),1)) Ys(randperm(size(Ys,1),1))];
end