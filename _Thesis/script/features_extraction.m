
% current_enc_features = encodeFeatures(data_collected_current.results,2800,20,1000,0.004,4);
% force_enc_features = encodeFeatures(data_collected_force.results,180,20,1000,0.004,4);
% torque_enc_features = encodeFeatures(data_collected_torque.results,180,20,1000,0.004,4);
% vibration_enc_features = encodeFeatures(data_collected_vibration.results,2800,20,1000,0.004,4);
% speed_enc_features = encodeFeatures(data_collected_speed.results,180,20,1000,0.004,4);

% 
% 
% 

% csvwrite('data_collected_current_enc.csv',current_enc_features.features)
% csvwrite('data_collected_force_enc.csv',force_enc_features.features)
% csvwrite('data_collected_torque_enc.csv',torque_enc_features.features)
% csvwrite('data_collected_vibration_enc.csv',vibration_enc_features.features)
% csvwrite('data_collected_speed_enc.csv',speed_enc_features.features)



arr = [data_collected_current,...
         data_collected_force,...
         data_collected_torque,...
         data_collected_vibration,...
         data_collected_speed];   
len = [200,200,200,200,200];
        
extract(arr,'results',len,20,100,0.001,4)
extract(arr,'fft',len,20,100,0.001,4)


function y = extract(arr,typeOfData,len,hiddenSize,epcs,l2,sparity)
    
   measures = {'current';'force';'torque';'vibration';'speed'};   
   for i=1:length(arr)
       d = arr(i).(typeOfData);
       d_size = size(d);
       extracted = zeros(hiddenSize+4,d_size(2));
       for j = 1:4
          enc = encodeFeatures(d(:,(j-1)*d_size(2)/4+1:j*d_size(2)/4),len(i),hiddenSize,epcs,l2,sparity);
          extracted(:,((j-1)*d_size(2)/4+1:j*d_size(2)/4)) = enc.features;
       end
       csvwrite(strcat(measures{i},'_',typeOfData,'_',num2str(len(i)),'_',num2str(hiddenSize),'_',num2str(epcs),'.csv'),extracted)
   end


end