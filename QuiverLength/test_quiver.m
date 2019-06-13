[x,y] = meshgrid(-2:.2:2,-1:.15:1);
z = x .* exp(-x.^2 - y.^2);
[u,v,w] = surfnorm(x,y,z);
q = quiver3(x,y,z,u,v,w); hold on; surf(x,y,z); hold off;
drawnow;
view(180,0);
mag = 0.1*ones(size(u));
SetQuiverLength(q,mag);
