function [theta_max,A,theta_A,B] = had_fit_sin(OPT_S,ints)
X=OPT_S.H_hat*ints;
phases = OPT_S.phases;
% ints = A*cos(phases + theta) + B
A = sqrt(X(1)^2+X(2)^2);
theta_A = atan2(X(2),X(1));
B = X(3);
theta_max = -theta_A;
x_est = A*cos(phases+theta_A)+B;
figure(1251234);plot(phases,ints);hold on;
plot(phases,x_est);hold off;

