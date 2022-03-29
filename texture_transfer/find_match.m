function matchPos = find_match(sample, target, out, curPos, blockSize, errorTolerance,alpha,isFirst)
    [M,N,~]=size(sample);
    X=curPos(1);
    Y=curPos(2);
    
    errors=zeros(M-blockSize+1,N-blockSize+1);
    
    %% calc error according to Euler-distance
    for i=1:M-blockSize+1
        for j=1:N-blockSize+1

            error1=target(X:X+blockSize-1,Y:Y+blockSize-1,:)-sample(i:i+blockSize-1,j:j+blockSize-1,:);
            error1=error1.*error1;
            
            if isFirst==0
                error2=out(X:X+blockSize-1,Y:Y+blockSize-1,:)-sample(i:i+blockSize-1,j:j+blockSize-1,:);
                error2=error2.*error2;
            else
                error2=0;
            end

            error=(1-alpha)*sum(sum(sum(error1)))+alpha*sum(sum(sum(error2)));
            
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
    matchPos=[ Xs(randperm(size(Xs,1),1)) Ys(randperm(size(Ys,1),1))];
end
