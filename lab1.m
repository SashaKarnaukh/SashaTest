clc;clear all;close all;
load ('myfile')
%1-2
Fs=2000;%��
Sa=mean(Ms);%����������� ���������
figure(1)
plot(tasr,Sa)
grid on
Umod=Sa([150 250 300 349 420 440 445 525 580 594 610 615 660 676 730 810 850 1000 1050 1151 1250 1300 1420 1550 1609 1800 1900]);
tmod=[150 250 300 349 420 440 445 525 580 594 610 615 660 676 730 810 850 1000 1050 1151 1250 1300 1420 1550 1609 1800 1900]/Fs;
figure(2)
plot(tmod,Umod,'b-',tmod,Umod,'r*')
grid on
T=length(Sa)/Fs;
Tend=T-1/Fs;
tnew=0:1/Fs:Tend;
Unew1=interp1(tmod,Umod,tnew,'linear');
Unew2=interp1(tmod,Umod,tnew,'cubic');
Unew3=interp1(tmod,Umod,tnew,'spline');
[R1,P1]=corrcoef(Unew1,Sa);
[R2,P2]=corrcoef(Unew2,Sa);
[R3,P3]=corrcoef(Unew3,Sa);
figure(3)
plot(tnew,Unew1,'r',tnew,Unew2,'g',tnew,Unew3,'b')
grid on
snr=30;%��
Sm=Unew3;
figure(4)
plot(tnew,Sm)
grid on
Mm=zeros(100,length(Sm));
for ii=1:100
    Mm(ii,:)=awgn(Sm,snr);
end
Sma=mean(Mm);
sigmai_r=std(Ms(5,161:255));
sigmaa_r=std(Sa(161:255));
N_r=sigmai_r/sigmaa_r
sigmai_mod=std(Mm(5,161:255));
sigmaa_mod=std(Sma(161:255));
N_mod=sigmai_mod/sigmaa_mod
%3
Umod_patol=Umod;
Umod_patol(5)=-0.27;
Sm_patol=interp1(tmod,Umod_patol,tnew,'spline');
Sm_patol(1:181)=0.001;
figure(5)
plot(tnew,Sm_patol)
grid on
%%%%4
%4.1
%�����������
s1_r=2*fft(Sa)/length(Sa);
sa1_r=abs(s1_r);
sf1_r=phase(s1_r);
f=0:1/T:Fs-1/T;
figure(6)
subplot(3,1,1)
plot(tasr,Sa)
title('����������� ������')
xlabel('time')
ylabel('Sa')
grid on
subplot(3,1,2)
plot(f,sa1_r)
title('�������� ��������������')
xlabel('f')
ylabel('�(f)')
grid on
xlim([0 500])
subplot(3,1,3)
plot(f,sf1_r)
title('������ ��������������')
xlabel('f')
ylabel('Phase(f)')
grid on
xlim([0 500])

%���������
s2_r=2*fft(Ms(5,:))/length(Ms(5,:));
sa2_r=abs(s2_r);
sf2_r=phase(s2_r);
figure(7)
subplot(3,1,1)
plot(tasr,Ms(5,:))
title('��������� ������')
xlabel('time')
ylabel('Ms(5)')
grid on
subplot(3,1,2)
plot(f,sa2_r)
title('�������� ��������������')
xlabel('f')
ylabel('���')
grid on
xlim([0 500])
subplot(3,1,3)
plot(f,sf2_r)
title('������ ��������������')
xlabel('f')
ylabel('Phase(f)')
grid on
xlim([0 500])

%4.2/4.4
%�����
s1_norm=2*fft(Sm(1:480))/length(Sm(1:480));
sa1_norm=abs(s1_norm);
sf1_norm=phase(s1_norm);
figure(8)
subplot(3,1,1)
title('������ ��� � ����')
plot(tnew(1:480),Sm(1:480))
xlabel('time')
ylabel('Sm_norm')
grid on
subplot(3,1,2)
plot(f(1:480),sa1_norm)
title('�������� ��������������')
xlabel('f')
ylabel('���')
grid on
xlim([0 100])
subplot(3,1,3)
plot(f(1:480),sf1_norm)
title('������ ��������������')
xlabel('f')
ylabel('Phase(f)')
grid on
xlim([0 100])

%��������
s1_patol=2*fft(Sm_patol(1:480))/length(Sm_patol(1:480));
sa1_patol=abs(s1_patol);
sf1_patol=phase(s1_patol);
figure(9)
subplot(3,1,1)
title('������ ��� � ������㳺�')
plot(tnew(1:480),Sm_patol(1:480))
xlabel('time')
ylabel('Sm_patol')
grid on
subplot(3,1,2)
plot(f(1:480),sa1_patol)
title('�������� ��������������')
xlabel('f')
ylabel('���')
grid on
xlim([0 100])
subplot(3,1,3)
plot(f(1:480),sf1_patol)
title('������ ��������������')
xlabel('f')
ylabel('Phase(f)')
grid on
xlim([0 100])

%4.3
for kk=1:length(Sa)
    if f(kk)<41
        n1=kk;%������ ���� ����� ����� ������
    else if f(kk)<42
            n2=kk;%����� ���� ����� ������ ������
        else if f(kk)<101
                n3=kk;%������ ���� ����� ������ ������
            end
        end
    end
end
%�����������
sp1_high_r=sa1_r(n2:n3)*sa1_r(n2:n3)';%������ ��
sp1_low_r=sa1_r(1:n1)*sa1_r(1:n1)';%������ ��
vidn1=sp1_high_r./sp1_low_r
%���������
sp2_high_r=sa2_r(n2:n3)*sa2_r(n2:n3)';%������ ��
sp2_low_r=sa2_r(1:n1)*sa2_r(1:n1)';%������ ��
vidn2=sp2_high_r./sp2_low_r

%4.5
ind=find(round(f)==10);
df1=f(1:ind);
df2=f(ind+1:480);
%�����
sp_high_norm=sa1_norm(1:ind)*sa1_norm(1:ind)';%������ ������ � ����������� df1
sp_low_norm=sa1_norm(ind+1:480)*sa1_norm(ind+1:480)';%������ ������ ��� ���������� df2
vidn_norma=sp_high_norm./sp_low_norm
%��������
sp_high_patol=sa1_patol(1:ind)*sa1_patol(1:ind)';%������ ������ � ����������� df1
sp_low_patol=sa1_patol(ind+1:480)*sa1_patol(ind+1:480)';%����� ������ ��� ���������� df2
vidn_patol=sp_high_patol./sp_low_patol

%%%%%%% 5 
%5.1
snr1=10;
snr2=100;
Sm10=awgn(Sm,snr1);
Sm100=awgn(Sm,snr2);
%5.2
Sm50=Sm+0.05*sin(2*pi*50*tnew);
%5.3
%� ����� 10��
s10=2*fft(Sm10)/length(Sm10);
sa10=abs(s10);
sf10=phase(s10);
figure(10)
subplot(3,1,1)
plot(tnew,Sm10)
title('������ ��� � ����� 10��')
xlabel('time')
ylabel('Sm10')
grid on
subplot(3,1,2)
plot(f,sa10)
title('�������� ��������������')
xlabel('f')
ylabel('���')
grid on
xlim([0 300])
subplot(3,1,3)
plot(f,sf10)
title('������ ��������������')
xlabel('f')
ylabel('Phase(f)')
grid on
xlim([0 300])
%�� ����� 100��
s100=2*fft(Sm100)/length(Sm100);
sa100=abs(s100);
sf100=phase(s100);
figure(11)
subplot(3,1,1)
plot(tnew,Sm100)
title('������ ��� � ����� 100��')
xlabel('time')
ylabel('Sm100')
grid on
subplot(3,1,2)
plot(f,sa100)
title('�������� ��������������')
xlabel('f')
ylabel('���')
grid on
xlim([0 300])
subplot(3,1,3)
plot(f,sf100)
title('������ ��������������')
xlabel('f')
ylabel('Phase(f)')
grid on
xlim([0 300])
%�� ��������� �������
s50=2*fft(Sm50)/length(Sm50);
sa50=abs(s50);
sf50=phase(s50);
figure(12)
subplot(3,1,1)
plot(tnew,Sm50)
title('������ ��� � ��������� ������� 50��')
xlabel('time')
ylabel('Sm50')
grid on
subplot(3,1,2)
plot(f,sa50)
title('�������� ��������������')
xlabel('f')
ylabel('���')
grid on
xlim([0 300])
subplot(3,1,3)
plot(f,sf50)
title('������ ��������������')
xlabel('f')
ylabel('Phase(f)')
grid on
xlim([0 300])

%%%%% 6
%6.1
figure(13)
subplot(3,1,1)
pburg(Sa,3)%����� �����
subplot(3,1,2)
pwelch(Sa)%����� ����� (�������� ������ �� ��������,�� ��������������)
subplot(3,1,3)
pyulear(Sa,3)%��������������� ����� ���-�������

%6.2
figure(14)
subplot(2,1,1)
periodogram(Sa)%������������� �����
subplot(2,1,2)
[spec,fspec,tspec]=specgram(Sa,[],[],f,Fs);
plot(fspec,spec);
grid on

%%%% ������� ��
%4.1(��� ���������� �������)
Sm_gaus=Sm+0.05*wgn(1,length(Sm),0);

