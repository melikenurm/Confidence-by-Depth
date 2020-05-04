function depth = nodedepth(node)
depth = 0;
while node~=0
    depth = depth + 1;
    node = floor(node/2);
end
end