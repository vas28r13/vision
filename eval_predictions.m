function [num_tests, TP, FP, FN, TN] = eval_predictions(compare)

[num_tests, m] = size(compare);
TP = 0;
FP = 0;
FN = 0;
TN = 0;

for i = 1:num_tests
    if compare(i,2) == 1 && compare(i,1) == compare(i,2)
        TP = TP + 1;
    end
    if compare(i,2) == 1 && compare(i,1) ~= compare(i,2)
        FN = FN + 1;
    end
    if compare(i,2) == -1 && compare(i,1) == compare(i,2)
        TN = TN + 1;
    end
    if compare(i,2) == -1 && compare(i,1) ~= compare(i,2)
        FP = FP + 1;
    end
end