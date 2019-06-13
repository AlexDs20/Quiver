function SetQuiverLength(q,mags)
%--------------------------------------------------
% function SetQuiverLength(q,mags)
%
%   Function that sets the length of the quiver
%   You can give a list of length (in x,y axis units), the function will rescale the vectors to the right length
%
% Input: q    = handle to quiver plot, can be quiver or quiver3
%        mags = Desired length of each vector in units of the x,y axis
%               If mags is a scalar, all the vector will have that length
%
%--------------------------------------------------

%// Start by removing the autoscale option
set(q,'AutoScale','Off');

H = get(q.Head);
T = get(q.Tail);

%// Handle input mags
if isempty(mags)
  warning('No input was given for the length of the vectors. They are now all of length 1.');
  mags = ones(size(T.VertexData,2)/2,1);
elseif numel(mags) == 1
  mags = repmat(mags,size(T.VertexData,2)/2,1);
elseif size(mags) == size(q.XData)
  mags = reshape(mags,[],1);
elseif isrow(mags)
  mags = mags';
elseif numel(mags)~=size(T.VertexData,2)/2
  warning('Different number of magnitudes and quiver vectors!');
  return;
else
  warning('Bug when calling SetQuiverLength function!');
  return;
end

%// Reshape the head and the tail
%// The head has 3 vertices and the tail has 2.
Tail_ori = reshape(T.VertexData,size(T.VertexData,1),2,[]);
Head_ori = reshape(H.VertexData,size(H.VertexData,1),3,[]);

%// Measure original length of Head and Tail
Tail_length = squeeze(sqrt(sum(diff(Tail_ori,1,2).^2,1)));
Head_length = squeeze(sqrt(sum(diff(Head_ori(:,[1,2],:),1,2).^2,1)));

%// Head-Tail original ratio
Length_ratio = Head_length./Tail_length;

%// Direction tail
Tail_dir = diff(Tail_ori,1,2)./permute(Tail_length(:,:,ones(size(T.VertexData,1),1)),[3 2 1]);

%// Directions of head
Head_dir_a = diff(Head_ori(:,[2,1],:),1,2)./permute(Head_length(:,:,ones(size(H.VertexData,1),1)),[3 2 1]);
Head_dir_b = diff(Head_ori(:,[2,3],:),1,2)./permute(Head_length(:,:,ones(size(H.VertexData,1),1)),[3 2 1]);

%// New length of head
Head_mag = mags.*Length_ratio;
Head_mag = permute(Head_mag(:,:,ones(size(H.VertexData,1),1)),[3 2 1]);

%// New Tail End = start of tail + magnitude*normalized direction
TailVertex = Tail_ori;
TailVertex(:,2,:) = TailVertex(:,1,:) +  ...
            permute(mags(:,:,ones(size(T.VertexData,1),1)),[3 2 1]) .*  Tail_dir;

%// Middle point of Head is same as end of Tail
HeadVertex = Head_ori;
HeadVertex(:,2,:) = TailVertex(:,2,:);

%// Head vector a
HeadVertex(:,1,:) = HeadVertex(:,2,:) + Head_mag .* Head_dir_a;
%// Head vector b
HeadVertex(:,3,:) = HeadVertex(:,2,:) + Head_mag .* Head_dir_b;


%// If the vector is originally of size 0, the vectors are now NaN.
%// Change those back to have just a simple "single point"
Idx_NaN = find(isnan(squeeze(TailVertex(1,end,:))));
TailVertex(:,end,Idx_NaN) = TailVertex(:,1,Idx_NaN);
HeadVertex(:,:,Idx_NaN) = repmat(TailVertex(:,1,Idx_NaN),1,3,1);

%// Reshape the data
HeadVertex = reshape(HeadVertex,size(H.VertexData,1),[]);
TailVertex = reshape(TailVertex,size(T.VertexData,1),[]);

pause(0.0102)

%// Set the data to the quiver properties
set(q.Head,'VertexData',HeadVertex);
set(q.Tail,'VertexData',TailVertex);
