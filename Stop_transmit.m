stop(ses2);
% pause(1)
ses2.release()
ses2.IsContinuous = false;
delete(lho);
delete(ses2);
clear ses2 lho