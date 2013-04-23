function [iou] = iou(A, B)

iou = sum(vec(A & B))./sum(vec(A | B));
