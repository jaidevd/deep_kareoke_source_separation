function [target_stems, other_stems] = load_stems(dataset, index)
% [target_stems, other_stems] = load_stems(dataset, index)
% load target and nontarget stems for a given song from json dataset
    target_stems = [];
    other_stems = [];
    
    function audio = load_stem(stem)
        stem_path = strcat(dataset.base_path, stem);
        audio = audioread( stem_path );
        audio = mean(audio,2);
    end

    mix = dataset.mixes{index};
    
    for i = 1:length(mix.target_stems)
        stem = load_stem(mix.target_stems{i});
        target_stems = [target_stems;stem'];
    end
    
    for i = 1:length(mix.other_stems)
        stem = load_stem(mix.other_stems{i});
        other_stems = [other_stems;stem'];
    end

end