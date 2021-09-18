function y = encodeFeatures(data,len,hiddenSize,epcs,l2,sparity)
   tail = data(end-3:end,:);
   selected = data;
   
   autoenc = trainAutoencoder(selected,hiddenSize,...
         'MaxEpochs',epcs,...
         'EncoderTransferFunction','logsig',...
         'DecoderTransferFunction','purelin',...
         'L2WeightRegularization',l2,...
         'SparsityRegularization',sparity,...
         'SparsityProportion',0.10);
%    pr = predict(autoenc,selected);
   features = encode(autoenc,selected);
   pr = predict(autoenc,selected);
   reconstruct.features = [features;tail];
   reconstruct.pr = [pr;tail];
%    y = autoenc;
   y = reconstruct;
 
end