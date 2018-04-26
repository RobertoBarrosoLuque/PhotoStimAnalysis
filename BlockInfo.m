function [BlockInf] =  BlockInfo(TrialInf, trial_switch,task)
clear i; %task = 1 if there is more than 2 conditions 0 otherwise
i = 0;

all_correct = find(TrialInf(:,2)==1);

%check to see if there were rule switches
if isempty(trial_switch)~=1
    for n= [1 trial_switch]
        i=i+1;
        if n == 1
            start = 1; endd = trial_switch(1);
        elseif n == trial_switch(length(trial_switch))
            start = trial_switch(length(trial_switch));
            endd=length(TrialInf);
        else
            start = n; endd = trial_switch(i);
        end
        
        correct = find(TrialInf(start:endd,2)==1);
        
        %Getting percent correct checker and no checker per each block
        checker = find(TrialInf(start:endd,5)==1);
        checker_correct = length(intersect(checker,correct));
        per_check_corr = checker_correct/length(checker);
        
        nocheck =  find(TrialInf(start:endd,5)==0);
        nocheck_correct =  length(intersect(nocheck,correct));
        per_nocheck_corr = nocheck_correct/length(nocheck);
        
        BlockInf(i).CheckCorrect = per_check_corr;
        BlockInf(i).NochCorrect =  per_nocheck_corr;
        
        
        %Getting percent correct right vs left per each block
        right = find(TrialInf(start:endd,4)==-1);
        right_correct = length(intersect(right,correct));
        per_right_corr = right_correct/ length(right);
        
        
        left = find(TrialInf(start:endd,4)==1);
        left_correct = length(intersect(left,correct));
        per_left_corr = left_correct/ length(left);
        
        BlockInf(i).RightCorrect = per_right_corr;
        BlockInf(i).LeftCorrect =  per_left_corr;
        
        %Getting Percent Correct per each condition per block
        %Vertical grating
        vert = find(TrialInf(start:endd,8)==1);
        vert_correct = length(intersect(vert,correct));
        per_vert_corr = vert_correct/ length(vert);
        vertNonch = intersect(vert,nocheck); vertNonch_correct = length(intersect(vertNonch,correct))/length(vertNonch);
        
        BlockInf(i).VertCorrect = per_vert_corr;
        BlockInf(i).VertNonchCorrect = vertNonch_correct;
        
        %Horizontal grating
        horz = find(TrialInf(start:endd,8)==2);
        horz_correct = length(intersect(horz,correct));
        per_horz_corr = horz_correct/ length(horz);
        horzNonch = intersect(horz,nocheck); horzNonch_correct = length(intersect(horzNonch,correct))/length(horzNonch);
        
        BlockInf(i).HorzCorrect = per_horz_corr;
        BlockInf(i).HorzNonchCorrect = horzNonch_correct;
        
        %Angled Grating 3 (68 deg)
        angle1 = find(TrialInf(start:endd,8)==3);
        angle1_correct = length(intersect(angle1,correct));
        per_angle1_corr = angle1_correct/ length(angle1);
        angle1Nonch = intersect(angle1,nocheck); angle1Nonch_correct = length(intersect(angle1Nonch,correct))/length(angle1Nonch);
        
        BlockInf(i).angle1Correct = per_angle1_corr;
        BlockInf(i).angle1NonchCorrect = angle1Nonch_correct;
        
        %Angled Grating 4 (22 deg)
        angle2 = find(TrialInf(start:endd,8)==4);
        angle2_correct = length(intersect(angle2,correct));
        per_angle2_corr = angle2_correct/ length(angle2);
        angle2Nonch= intersect(angle2,nocheck); angle2Nonch_correct = length(intersect(angle2Nonch,correct))/length(angle2Nonch);
        
        BlockInf(i).angle2Correct = per_angle2_corr;
        BlockInf(i).angle2NonchCorrect = angle2Nonch_correct;    
    end
    
  % No rule switch -------------------------------------------------------  
else 
        start=1;endd=length(TrialInf);i=1
        %only one block so lopp through all trials
        correct = find(TrialInf(start:endd,2)==1);
        
        %Getting percent correct checker and no checker per each block
        checker = find(TrialInf(start:endd,5)==1);
        checker_correct = length(intersect(checker,correct));
        per_check_corr = checker_correct/length(checker);
        
        nocheck =  find(TrialInf(start:endd,5)==0);
        nocheck_correct =  length(intersect(nocheck,correct));
        per_nocheck_corr = nocheck_correct/length(nocheck);
        
        BlockInf(i).CheckCorrect = per_check_corr;
        BlockInf(i).NochCorrect =  per_nocheck_corr;
        
        
        %Getting percent correct right vs left per each block
        right = find(TrialInf(start:endd,4)==-1);
        right_correct = length(intersect(right,correct));
        per_right_corr = right_correct/ length(right);
        
        
        left = find(TrialInf(start:endd,4)==1);
        left_correct = length(intersect(left,correct));
        per_left_corr = left_correct/ length(left);
        
        BlockInf(i).RightCorrect = per_right_corr;
        BlockInf(i).LeftCorrect =  per_left_corr;
        
        %Getting Percent Correct per each condition per block
        %Vertical grating
        vert = find(TrialInf(start:endd,8)==1);
        vert_correct = length(intersect(vert,correct));
        per_vert_corr = vert_correct/ length(vert);
        vertNonch = intersect(vert,nocheck); vertNonch_correct = length(intersect(vertNonch,correct))/length(vertNonch);
        
        BlockInf(i).VertCorrect = per_vert_corr;
        BlockInf(i).VertNonchCorrect = vertNonch_correct;
        
        %Horizontal grating
        horz = find(TrialInf(start:endd,8)==2);
        horz_correct = length(intersect(horz,correct));
        per_horz_corr = horz_correct/ length(horz);
        horzNonch = intersect(horz,nocheck); horzNonch_correct = length(intersect(horzNonch,correct))/length(horzNonch);
        
        BlockInf(i).HorzCorrect = per_horz_corr;
        BlockInf(i).HorzNonchCorrect = horzNonch_correct;
        
end
    

%get values in matrix form
yLR=[]; yCnC = []; yconds =[]; ynochconds = []; yPhotoStim = [];
for n=1:length(trial_switch)+1
    xLR = [BlockInf(n).RightCorrect  BlockInf(n).LeftCorrect];
    yLR = [yLR; xLR];
    
    xCnC = [BlockInf(n).CheckCorrect  BlockInf(n).NochCorrect];
    yCnC = [yCnC; xCnC];
    
    xconds = [BlockInf(n).VertCorrect  BlockInf(n).HorzCorrect BlockInf(n).angle1Correct BlockInf(n).angle2Correct];
    yconds = [yconds; xconds];
    
    nochconds = [BlockInf(n).VertNonchCorrect BlockInf(n).HorzNonchCorrect BlockInf(n).angle1NonchCorrect BlockInf(n).angle2NonchCorrect];
    ynochconds = [ynochconds; nochconds];
    
%     if size(TrialInf, 2)>9
%         xPhotoStim = [BlockInf(n).NonstimCorrect BlockInf(n).NonStim_StimBlockCorrect BlockInf(n).stimCorrect];
%         yPhotoStim = [yPhotoStim; xPhotoStim];
%     end
    
end

x_axis = 0:length(trial_switch)+2;

if task == 1
    subplot(2,4,3);
else
    subplot(3,1,2)
end
B = bar(yLR);
hold on;
B(1).FaceColor = 'g';B(2).FaceColor ='m'; B(1).EdgeColor =  'g'; B(2).EdgeColor = 'm';
legend([B(1) B(2)],'Right','Left'); legend('Location', 'northoutside');legend('Orientation','horizontal');legend('boxoff');
l=line([0  length(trial_switch)+2],[.5 .5]); set(l,'Color','k');
set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
hold off

if task == 1
    subplot(2,4,4);
else
    subplot(3,1,3)
end

xticks(x_axis)
B = bar(yCnC);
hold on;
B(1).FaceColor = 'g';B(2).FaceColor ='m'; B(1).EdgeColor =  'g'; B(2).EdgeColor = 'm';
legend([B(1) B(2)],'Checker','No Checker');legend('Location', 'northoutside');legend('Orientation','horizontal')
legend('boxoff');
l=line([0  length(trial_switch)+2],[.5 .5]); set(l,'Color','k');
set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
hold off

if task == 1
    subplot(2,2,3);
    xticks(x_axis)
    B = bar(ynochconds);
    hold off;
    B(1).FaceColor = 'g';B(2).FaceColor ='m'; B(1).EdgeColor =  'g'; B(2).EdgeColor = 'm';
    B(3).FaceColor = 'b';B(4).FaceColor ='r'; B(3).EdgeColor =  'b'; B(4).EdgeColor = 'r';
    legend([B(1) B(2) B(3) B(4)],'V','H', 'A1', 'A2');legend('Location', 'southoutside');legend('Orientation','horizontal')
    legend('boxoff')
    l=line([0  length(trial_switch)+2],[.5 .5]); set(l,'Color','k');
    set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    title('Percent Correct Per Condition')
    hold off
    
    subplot(2,2,4);
    xticks(x_axis)
    B = bar(yconds);
    hold on;
    B(1).FaceColor = 'g';B(2).FaceColor ='m'; B(1).EdgeColor =  'g'; B(2).EdgeColor = 'm';
    B(3).FaceColor = 'b';B(4).FaceColor ='r'; B(3).EdgeColor =  'b'; B(4).EdgeColor = 'r';
    legend([B(1) B(2) B(3) B(4)],'V','H', 'A1', 'A2');legend('Location', 'southoutside');legend('Orientation','horizontal')
    legend('boxoff')
    l=line([0  length(trial_switch)+2],[.5 .5]); set(l,'Color','k');
    set(get(get(l,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
    title('Percent Correct Per Condition (Non-Ch)')
    hold off
end

end