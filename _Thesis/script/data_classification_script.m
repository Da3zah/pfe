% Load files first by running files.m script ---------%
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
clc 

% data_x = load('./K001/N09_M07_F10_K001_2.mat');
% axis_x.low = data_x.('N09_M07_F10_K001_2').X(1);
% axis_x.high = data_x.('N09_M07_F10_K001_2').X(2);
% 
% HEALTHY = loadMultipleData(HEALTHY_files,'HEALTHY',1,9,7,10);
% OR = loadMultipleData(OR_files,'OR',2,9,7,10);
% IR = loadMultipleData(IR_files,'IR',3,9,7,10);
% OR_IR = loadMultipleData(OR_IR_files,'OR_IR',4,9,7,10);
% 
% HEALTHY1 = loadMultipleData(HEALTHY_files1,'HEALTHY',1,15,7,10);
% OR1 = loadMultipleData(OR_files1,'OR',2,15,7,10);
% IR1 = loadMultipleData(IR_files1,'IR',3,15,7,10);
% OR_IR1 = loadMultipleData(OR_IR_files1,'OR_IR',4,15,7,10);
% 
% HEALTHY2 = loadMultipleData(HEALTHY_files2,'HEALTHY',1,15,7,4);
% OR2 = loadMultipleData(OR_files2,'OR',2,15,7,4);
% IR2 = loadMultipleData(IR_files2,'IR',3,15,7,4);
% OR_IR2 = loadMultipleData(OR_IR_files2,'OR_IR',4,15,7,4);
% 
% HEALTHY3 = loadMultipleData(HEALTHY_files3,'HEALTHY',1,15,1,10);
% OR3 = loadMultipleData(OR_files3,'OR',2,15,1,10);
% IR3 = loadMultipleData(IR_files3,'IR',3,15,1,10);
% OR_IR3 = loadMultipleData(OR_IR_files3,'OR_IR',4,15,1,10);

% len = length(HEALTHY) * 4;
% 
% ALL__DATA(1:len) = [HEALTHY,HEALTHY1,HEALTHY2,HEALTHY3];
% ALL__DATA(len+1:len*2) = [OR,OR1,OR2,OR3];
% ALL__DATA(len*2+1:len*3) = [IR,IR1,IR2,IR3];
% ALL__DATA(len*3+1:len*4) = [OR_IR,OR_IR1,OR_IR2,OR_IR3];
%  
% len = length(HEALTHY) ;
% ALL__DATA(1:len) = HEALTHY;
% ALL__DATA(len+1:len*2) = OR;
% ALL__DATA(len*2+1:len*3) = IR;
% ALL__DATA(len*3+1:len*4) = OR_IR;
% save('ALL_DATA.mat','ALL__DATA')


% data_collected_current = classifyData(ALL__DATA,240,5000,'ph1',1,0);
% data_collected_force = classifyData(ALL__DATA,240,5000,'force',1,0);
% data_collected_vibration = classifyData(ALL__DATA,240,5000,'vibration',1,0);
% data_collected_speed = classifyData(ALL__DATA,240,5000,'speed',1,0);
% data_collected_torque = classifyData(ALL__DATA,240,5000,'torque',1,0);


% csvwrite('data_collected_current.csv',data_collected_current.results)
% csvwrite('data_collected_current_wpf.csv',data_collected_current.wp_features)
% csvwrite('data_collected_current_fft.csv',data_collected_current.fft)
% 
% csvwrite('data_collected_force.csv',data_collected_force.results)
% csvwrite('data_collected_force_wpf.csv',data_collected_force.wp_features)
% csvwrite('data_collected_force_fft.csv',data_collected_force.fft)
% 
% csvwrite('data_collected_torque.csv',data_collected_torque.results)
% csvwrite('data_collected_torque_wpf.csv',data_collected_torque.wp_features)
% csvwrite('data_collected_torque_fft.csv',data_collected_torque.fft)
% 
% csvwrite('data_collected_vibration.csv',data_collected_vibration.results)
% csvwrite('data_collected_vibration_wpf.csv',data_collected_vibration.wp_features)
% csvwrite('data_collected_vibration_fft.csv',data_collected_vibration.fft)
% 
% csvwrite('data_collected_speed1.csv',data_collected_speed.results)
% csvwrite('data_collected_speed1_wpf.csv',data_collected_speed.wp_features)
% csvwrite('data_collected_speed1_fft.csv',data_collected_speed.fft)

% features_extraction

plotMultiple(ALL__DATA,'ph1','Current(A)',axis_x.high.Data,1,[0,4],[2,4],'currentPlot.jpg')
plotMultiple(ALL__DATA,'vibration','Amplitude(DB)',axis_x.high.Data,2,[0,4],[2,6],'vibrationPlot.jpg')
plotMultiple(ALL__DATA,'force','Force(N)',axis_x.low.Data,3,[0,4],[1000,1400],'forcePlot.jpg')
plotMultiple(ALL__DATA,'torque','N.m',axis_x.low.Data,4,[0,4],[1.2,1.5],'torquePlot.jpg')

function y = classifyData(data,numberOfSamples,inputSize,variable,envelopeBool,normalizeBool)
 numberOfExamples = length(data) / 4;
 results = zeros(inputSize+4,numberOfSamples * 4);
 features = zeros(18,numberOfSamples * 4);
 results_fft = zeros(inputSize+4,numberOfSamples * 4);
 for i = 0:3
   for j = 1:numberOfSamples
    index = i*numberOfExamples + j   ;
    result = data(index).(variable)(1:inputSize);
    result_fft = abs(fft(result/length(result)));
    if(envelopeBool)
       result = envelope(result);
       result_fft = abs(fft(result/length(result)));
    end
    if(normalizeBool)
     result = 2 * (result-min(result))/(max(result)-min(result)) - 1;
     result_fft =  2 * (result_fft-min(result_fft))/(max(result_fft)-min(result_fft)) - 1;
    end 
    wve =  wenergy(wpdec(result,3,'db1'));
    result_fft = abs(fft(result/length(result)));
    pk1 = peak2rms(result);
    pk2 = peak2rms(wve(2:8));
    sk1 = skewness(result);
    sk2 = skewness(wve(2:8));
    kr1 = kurtosis(result);
    kr2 = kurtosis(wve(2:8));
    test = [result,data(index).rs,data(index).lt,data(index).rf,data(index).class];
    test_fft = [result_fft,data(index).rs,data(index).lt,data(index).rf,data(index).class];
    results(:,i * numberOfSamples + j) = test(:);
    results_fft(:,i * numberOfSamples + j) = test_fft(:);   
    features(:,i * numberOfSamples + j) = [wve,pk1,pk2,sk1,sk2,kr1,kr2,data(index).rs,data(index).lt,data(index).rf,data(i*numberOfExamples + j).class];
   end
   y.results = results;
   y.wp_features = features;
   y.fft = results_fft;
 end
 
end
 

function y = loadData(x,type,class,rs,lt,rf)
    loaded__file = load(x{1,1});
    loaded__file__fields = fieldnames(loaded__file);
    loaded__file__name = loaded__file__fields{1};
    data = loaded__file.(loaded__file__name);
    data__y = data.Y;
    test.name = x{1,1};
    test.type = type;
    test.class = class;
    test.rs = rs;
    test.lt = lt;
    test.rf = rf;
    test.force = data__y(1).Data;
    test.ph1 = data__y(2).Data;
    test.speed = data__y(4).Data;
    test.vibration = data__y(7).Data;
    test.torque = data__y(6).Data;
    y= test;
 return 
end


function y = loadMultipleData(x,type,class,rs,lt,rf)
   allData = [];
     for i = 1:size(x,1)
        file = loadData(x(i),type,class,rs,lt,rf);
        allData = [allData,file]  ;
     end
   y = allData;
return
end



function plotMultiple(data,measure,name,x_scale,num,xlimit,ylimit,figName)
fig = figure(num, 'position', [0,0,600,400]);
size(x_scale)
size(data(2).(measure))
size(envelope(data(2).(measure)))
subplot(2,2,1)
h2 = envelope(data(2).(measure));
plot(x_scale,h2)
title('HEALTHY test example')
ylabel(name)
xlabel('Time(s)')
ylim(ylimit)
xlim(xlimit)

subplot(2,2,2)
or2 = envelope(data(65).(measure));
plot(x_scale,or2)
title('OR damage test example')
xlabel('Time(s)')
ylabel(name)
ylim(ylimit)
xlim(xlimit)

subplot(2,2,3)
ir2 = envelope(data(124).(measure));
plot(x_scale,ir2)
title('IR damage test example')
ylabel(name)
xlabel('Time(s)')
ylim(ylimit)
xlim(xlimit)

subplot(2,2,4)
oi2 = envelope(data(200).(measure));
plot(x_scale,oi2)
title('OR+IR damage test example')
ylabel(name)
xlabel('Time(s)')
ylim(ylimit)
xlim(xlimit)

saveas(fig,figName)
% figure(num + 4)
% 
% subplot(2,2,1)
% h1 = envelope(data(3).(measure));
% plot(x_scale,h1)
% title('HEALTHY test example')
% ylabel(name)
% xlabel('Time(s)')
% ylim(ylimit)
% xlim(xlimit)
% 
% subplot(2,2,2)
% or1 = envelope(data(19).(measure));
% plot(x_scale,or1)
% title('OR damaged test example')
% ylabel(name)
% xlabel('Time(s)')
% ylim(ylimit)
% xlim(xlimit)
% 
% subplot(2,2,3)
% ir1 = envelope(data(25).(measure));
% plot(x_scale,ir1)
% title('IR damaged test example')
% ylabel(name)
% xlabel('Time(s)')
% ylim(ylimit)
% xlim(xlimit)
% 
% subplot(2,2,4)
% oi1 = envelope(data(47).(measure));
% plot(x_scale,oi1)
% title('OR+IR damaged test example')
% ylabel(name)
% xlabel('Time(s)')
% ylim(ylimit)
% xlim(xlimit)

% figure(num)
% 
% subplot(2,2,1)
% h1 = envelope(data(3).(measure));
% plot(x_scale,abs(fft(h1/length(x_scale))))
% title('HEALTHY test example 1')
% ylabel(name)
% xlabel('Time(s)')
% % ylim(ylimit)
% % xlim(xlimit)
% 
% subplot(2,2,2)
% or1 = envelope(data(19).(measure));
% plot(x_scale,abs(fft(or1/length(x_scale))))
% title('OR damaged test example 1')
% ylabel(name)
% xlabel('Time(s)')
% % ylim(ylimit)
% % xlim(xlimit)
% 
% subplot(2,2,3)
% ir1 = envelope(data(25).(measure));
% plot(x_scale,abs(fft(ir1/length(x_scale))))
% title('IR damaged test example 1')
% ylabel(name)
% xlabel('Time(s)')
% % ylim(ylimit)
% % xlim(xlimit)
% 
% subplot(2,2,4)
% oi1 = envelope(data(47).(measure));
% plot(x_scale,abs(fft(oi1/length(x_scale))))
% title('OR+IR damaged test example 1')
% ylabel(name)
% xlabel('Time(s)')
% % ylim(ylimit)
% % xlim(xlimit)


end






