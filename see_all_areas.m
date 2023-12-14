clear;
all_segments_struct = struct('segment', {}, 'area', {}, 'best_fit_circle_correlation', {}, 'best_fit_circle_radius', {}, 'best_fit_circle', {});
all_radius = zeros(18, 1);
all_corrs = zeros(18, 1);
disp('making a struct')
tic
for i = 1:18
    

    fname = strcat('c', num2str(i), '.mat');
    seg = load(fname).segment;
    area = load(fname).area;

    all_segments_struct(i).segment = seg;
    all_segments_struct(i).area = area;

    % Find centroid of segmented areas
    [centroidX, centroidY] = calculate_centroid(seg);
    
    radius_range = 100:2:150;
    corr_vals = zeros(length(radius_range), 1);
    c = 1;
    for r = radius_range
        circle_img = generate_circle(centroidX, centroidY, r, size(seg, 1), size(seg, 2));
        corr_vals(c) = corr2(seg, circle_img);
        c = c + 1;
    end
    

    % subplot(2,1,1)
    % imagesc(seg)
    % hold on
    % % plot centroid
    % plot(centroidX, centroidY, 'r*');
    % sgtitle(strcat('c', num2str(i), '-Area: ', num2str(area)));
    % hold off;

    % subplot(2,1,2)
    % plot(radius_range, corr_vals);
    % xlabel('Radius');
    % ylabel('Correlation');
    [max_corr, max_idx] = max(corr_vals);
    all_radius(i) = radius_range(max_idx);
    all_corrs(i) = max_corr;

    all_segments_struct(i).best_fit_circle_correlation = max_corr;
    all_segments_struct(i).best_fit_circle_radius = radius_range(max_idx);
    all_segments_struct(i).best_fit_circle = generate_circle(centroidX, centroidY, radius_range(max_idx), size(seg, 1), size(seg, 2));

    % sgtitle(strcat('Max Correlation: ', num2str(max_corr), ' at radius: ', num2str(radius_range(max_idx))));
    
    % pause;
    % clf;
end
toc

disp('sorting struct')
tic
sorted_all_segments_struct = arrange_masks_area_desc_order(all_segments_struct);  
toc

% for i = 1:length(sorted_all_segments_struct)
%     imagesc(sorted_all_segments_struct(i).segment)
%     title(['Area: ', num2str(sorted_all_segments_struct(i).area), ' Correlation: ', num2str(sorted_all_segments_struct(i).best_fit_circle_correlation), ' Radius: ', num2str(sorted_all_segments_struct(i).best_fit_circle_radius)]);
%     pause;
%     clf;
% end

disp('find arena masks')
tic
arena_masks = find_arena_masks(sorted_all_segments_struct);
if length(arena_masks) ~= 4
    error('Could not find 4 arena masks');
end
toc
for i = 1:4
    subplot(2,2,i)
    imagesc(arena_masks(i).mask);
end