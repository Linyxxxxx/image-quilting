function out = overlap_quilting(sample, blockSize, overlapWidth, out, curPos, blockPos)
    [Ms,Ns,Ks]=size(sample);
    [Mo,No,Ko]=size(out);
    
    Xc=curPos(1);
    Yc=curPos(2);
    Xb=blockPos(1);
    Yb=blockPos(2);
    
    %% non-overlap area
    out(Xc+overlapWidth:Xc+blockSize-1, Yc+overlapWidth:Yc+blockSize-1, :) = sample(Xb+overlapWidth:Xb+blockSize-1, Yb+overlapWidth:Yb+blockSize-1, :);
    
    %% vertical-overlap area
    if Yc==1
        out(Xc:Xc+blockSize-1,Yc:Yc+overlapWidth-1,:)=sample(Xb:Xb+blockSize-1,Yb:Yb+overlapWidth-1,:);
    else
        sampleFeature=zeros(blockSize, overlapWidth);
        outFeature=zeros(blockSize, overlapWidth);

        % feature
        for i=1:Ks
            sampleFeature(:,:)=sampleFeature(:,:)+sample(Xb:Xb+blockSize-1,Yb:Yb+overlapWidth-1,i);
        end
        for i=1:Ko
            outFeature(:,:)=outFeature(:,:)+out(Xc:Xc+blockSize-1,Yc:Yc+overlapWidth-1,i);
        end


        % dp
        dFeature=abs(sampleFeature-outFeature);
        dp=zeros(blockSize, overlapWidth);
        dp(1,:)=dFeature(1,:);
        for i=2:blockSize
            for j=1:overlapWidth
                if j==1
                    dp(i,j)=dFeature(i,j)+min([dp(i-1,j) dp(i-1,j+1)]);
                elseif j==overlapWidth
                    dp(i,j)=dFeature(i,j)+min([dp(i-1,j-1) dp(i-1,j)]);
                else
                    dp(i,j)=dFeature(i,j)+min([dp(i-1,j-1) dp(i-1,j) dp(i-1,j+1)]);
                end
            end
        end

        % backtracing
        path=zeros(blockSize);
        path(blockSize)=find(dp(blockSize,:)==min(dp(blockSize,:)),1,'first');
        for i=blockSize:-1:2
            if path(i)==1
                target=[dp(i-1,1) dp(i-1,2)];
                path(i-1)=find(target==min(target),1,'first');
            elseif path(i)==overlapWidth
                target=[dp(i-1,overlapWidth) dp(i-1,overlapWidth-1)];
                path(i-1)=overlapWidth+1-find(target==min(target),1,'first');
            else
                target=[dp(i-1,path(i)-1) dp(i-1,path(i)) dp(i-1,path(i)+1)];
                path(i-1)=path(i)-2+find(target==min(target),1,'first');
            end
        end

        % merge
        for i=1:blockSize
            out(Xc+i-1,Yc+path(i)-1:Yc+overlapWidth-1,:)=sample(Xb+i-1,Yb+path(i)-1:Yb+overlapWidth-1,:);
        end   
    end
    %% horizontal overlap area
    if Xc==1
        out(Xc:Xc+overlapWidth-1,Yc:Yc+blockSize-1,:)=sample(Xb:Xb+overlapWidth-1,Yb:Yb+blockSize-1,:);
    else
        sampleFeature=zeros(overlapWidth, blockSize);
        outFeature=zeros(overlapWidth, blockSize);

        % feature
        for i=1:Ks
            sampleFeature(:,:)=sampleFeature(:,:)+sample(Xb:Xb+overlapWidth-1,Yb:Yb+blockSize-1,i);
        end
        for i=1:Ko
            outFeature(:,:)=outFeature(:,:)+out(Xc:Xc+overlapWidth-1,Yc:Yc+blockSize-1,i);
        end


        % dp
        dFeature=abs(sampleFeature-outFeature);
        dp=zeros(overlapWidth, blockSize);
        dp(:,1)=dFeature(:,1);
        for i=2:blockSize
            for j=1:overlapWidth
                if j==1
                    dp(j,i)=dFeature(j,i)+min([dp(j,i-1) dp(j+1,i-1)]);
                elseif j==overlapWidth
                    dp(j,i)=dFeature(j,i)+min([dp(j-1,i-1) dp(j,i-1)]);
                else
                    dp(j,i)=dFeature(j,i)+min([dp(j-1,i-1) dp(j,i-1) dp(j+1,i-1)]);
                end
            end
        end

        % backtracing
        path=zeros(blockSize);
        path(blockSize)=find(dp(:,blockSize)==min(dp(:,blockSize)),1,'first');
        for i=blockSize:-1:2
            if path(i)==1
                target=[dp(1,i-1) dp(2,i-1)];
                path(i-1)=find(target==min(target),1,'first');
            elseif path(i)==overlapWidth
                target=[dp(overlapWidth,i-1) dp(overlapWidth-1,i-1)];
                path(i-1)=overlapWidth+1-find(target==min(target),1,'first');
            else
                target=[dp(path(i)-1,i-1) dp(path(i),i-1) dp(path(i)+1,i-1)];
                path(i-1)=path(i)-2+find(target==min(target),1,'first');
            end
        end

        % merge
        for i=1:blockSize
            out(Xc+path(i)-1:Xc+overlapWidth-1,Yc+i-1,:)=sample(Xb+path(i)-1:Xb+overlapWidth-1,Yb+i-1,:);
        end
    end
end


