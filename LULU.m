function y = LULU(x,n)
if iscolumn(x);x = x';end

seq = LOCAL_getSeq(x,1);
y = LOCAL_L(seq);

end



%% if even number of subSegments
function seq = LOCAL_getSeq(x,n)
if mod(n+1,2)==0
    for jj = 1:n+1
        count = 1;
        for ii= -(n+1)/2:(n+1)/2
            if ii<0
                seq{jj}(count,:) = [x(1:end) nan(1,abs(ii))];
                count = count+1;
                
            elseif ii>0
                seq{jj}(count,:) = [nan(1,ii) x(ii:end)];
                count = count+1;
                
            end
        end
    end
    %% Not working yet
    % %% if odd # of subseqs
    % if mod(n+1,2)~=0
    %     for jj = 1:n+1
    %         count = 1;
    %         for ii= (-n/2):(n/2)
    %             if ii<0
    %                 seq{jj}(count,:) = [x(1:end) nan(1,abs(ii))];
    %                 count = count+1;
    %
    %             elseif ii>0
    %                 seq{jj}(count,:) = [nan(1,ii) x(ii:end)];
    %                 count = count+1;
    %             elseif ii ==0
    %                 seq{jj}(count,:) = x;
    %                 count = count+1;
    %             end
    %
    %
    %             end
    %         end
    %     end
end
end

function y = LOCAL_L(seq)
for ii = 1:length(seq)
    mm(ii,:) = min(seq{ii});
end
    y = max(mm);
end


function y = LOCAL_U(seq)
for ii = 1:length(seq)
    mm(ii,:) = max(seq{ii});
end
    y = min(mm);
end



