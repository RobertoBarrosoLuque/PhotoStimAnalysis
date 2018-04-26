function [b_glm,dev_glm,stats_glm] = MLogReg(TrialInf)
%function to calculate the influence of previous reward history on current
%choice Y. 

%matrix with X1, X2,etc for log regression based on reward info
X_rew = zeros(8,length(TrialInf)); 
%matrix with X1, X2,etc for log regression based on choice info
X_choice=zeros(8,length(TrialInf));  

Choice_orig = TrialInf(:,9);

TrialInf(find(TrialInf(:,9)==-1),9) = 0; %choice of going left rep by 2, left = 2, right = 1
Choice_rep = TrialInf(:,9);


reward_orig = TrialInf(:,2);
TrialInf(find(TrialInf(:,2)==0),2) = 2; %change no rewards from 0 to 2

X_rew(1,1) = NaN; X_choice(1,1) = NaN;
for i = 2:length(TrialInf)
    X_rew(1,i) = TrialInf(i-1,2);
    X_choice(1,i) = TrialInf(i-1,9);
end 

X_rew(2,1:2) = NaN;
X_choice(2,1:2) = NaN;
for i = 3:length(TrialInf)
    X_rew(2,i) = TrialInf(i-2,2);
    X_choice(2,i) = TrialInf(i-2,9);
end 

X_rew(3,1:3) = NaN;
X_choice(3,1:3) = NaN;
for i = 4:length(TrialInf)
    X_rew(3,i) = TrialInf(i-3,2);
    X_choice(3,i) = TrialInf(i-3,9);
end 

X_rew(4,1:4) = NaN;
X_choice(4,1:4) = NaN;
for i = 5:length(TrialInf)
    X_rew(4,i) = TrialInf(i-4,2);
    X_choice(4,i) = TrialInf(i-4,9);
end 


X_rew(5,1:5) = NaN;
X_choice(5,1:5) = NaN;
for i = 6:length(TrialInf)
    X_rew(5,i) = TrialInf(i-5,2);
    X_choice(5,i) = TrialInf(i-5,9);
end 

X_rew(6,1:6) = NaN;
X_choice(6,1:6) = NaN;
for i = 7:length(TrialInf)
    X_rew(6,i) = TrialInf(i-6,2);
    X_choice(6,i) = TrialInf(i-6,9);
end 

X_rew(7,1:7) = NaN;
X_choice(7,1:7) = NaN;
for i = 8:length(TrialInf)
    X_rew(7,i) = TrialInf(i-7,2);
    X_choice(7,i) = TrialInf(i-7,9);
end 
i;

X_rew(8,1:8) = NaN;
X_choice(8,1:8) = NaN;
for i = 9:length(TrialInf)
    X_rew(8,i) = TrialInf(i-8,2);
    X_choice(8,i) = TrialInf(i-8,9);
end 

%using past choice data to predict current choice 
%B = mnrfit(X,Y) returns a matrix, B, of coefficient estimates for a multinomial 
%logistic regression of the nominal responses in Y(current choice) on the predictors in X(past choices).
% [B_ch,dev_ch,stats_ch] = mnrfit(X_choice',Choice_rep);
%errorbar(B(2:9),stats.se(2:9),'ko');xlim([0 9])

%create Y array (predicted) with binary vector by replacing -1 (lefts) with 0
%Y_lasso = Choice_orig; Y_lasso(find(Choice_orig==-1)) = 0;
%[B_lass,FitInfo] = lassoglm(X_choice',Y_lasso,'binomial','Link','logit'); 
%returns penalized maximum-likelihood fitted coefficients for a generalized linear model
%of the response Y to the data matrix X. The values in Y are assumed to have a Gaussian probability distribution.


% if size(B_ch(2:end),1)== size(X_choice,1)
%     theta = B_ch(2:end).*X_choice;
%     predicted = B_ch(1)+theta;
%     h_ch = sigmoid(predicted);
% else
%     h_ch = NaN;
% end

%using glmfit 0 = left, 1 = right
chc = ones(length(X_choice),2); 
chc(:,1) = Choice_rep;
[b_glm,dev_glm,stats_glm] = glmfit(X_choice',chc,'binomial','link','logit');



% predicted = B(1)+(B(2:end).*X_choice);
% h = sigmoid(predicted,0,1);
% y = h; y(find(y>=.5))=1; y(find(y<.5))=-1;


%using past reward data to predict if he will be rewarded
%[B_rw,dev_rw,stats_rw] = mnrfit(X_rew',TrialInf(:,2));

% if size(B_rw(2:end),1)== size(X_rew,1)
%     theta = B_rw(2:end).*X_rew;
%     predicted = B_ch(1)+theta;
%     h_rw = sigmoid(predicted);  
% else
%     h_rw = NaN;
% end



end 