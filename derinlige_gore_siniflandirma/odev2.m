function basaritotal=odev2(edata,tdata)
[x,y]=arffoku('C:\Users\Melike Nur Mermer\Desktop\36uci\36uci\d159.arff');
[satir,sutun]=size(x);
sinifsay=max(y);
%eorn{1,1}=1.foldun e�itim seti, eorn{1,2}=2.foldun e�itim seti
%datasetin yar�s� e�itim orne�i yar�s� test
eornsay=length(edata);
tornsay=length(tdata);
ensmsay=25;
%tekil a�ac�n e�itim seti training1
training_x=zeros(eornsay,sutun);
training_y=zeros(eornsay,1);
testing_x=zeros(tornsay,sutun);
testing_y=zeros(tornsay,1);
%e�itim ve test setlerinin olu�turulmas�
    for i=1:eornsay
        training_x(i,:)=x(edata(i),:);
        training_y(i,1)=y(edata(i),1);   
    end
    for i=1:tornsay
        testing_x(i,:)=x(tdata(i),:);
        testing_y(i,1)=y(tdata(i),1);      
    end
%tekil a�ac�n kulland��� e�itim setinin hangi indisteki elemanlar�n�
%alaca��n� belirleyen matris
bagger=randi(eornsay,ensmsay,eornsay);
%temel ��renicilerin kullanaca�� e�itim setlerinin giri�leri i�in bir
%multidimensional matrix (to_x) olu�turuldu.
%��k��lar� ba�ka bir matriste tutuluyor
to_x=zeros(eornsay,sutun,ensmsay);
to_y=zeros(eornsay,1,ensmsay);    
        for i=1:ensmsay
        for j=1:eornsay
        to_x(j,:,i)=training_x(bagger(i,j),:);
        to_y(j,1,i)=training_y(bagger(i,j),1);
        end
        end
%d�ng� i�inde a�a� olu�turabilmek i�in "dtrees" cell array olu�turulur.
dtrees = cell(1,ensmsay);       
for i=1:ensmsay
tree=fitctree(to_x(:,:,i),to_y(:,1,i),'Prune','off','MinLeafSize',1,'MinParentSize',2);
dtrees{i} = tree;
end
%test edilen �rneklerin 1.s�tunu sonu�, 2.s�tunu derinlik
to_tahmin=zeros(tornsay,3,ensmsay);
depths=zeros(tornsay,2,ensmsay);
treedpth=[];
for i=1:ensmsay
tree=dtrees{i};
treedpth(i)=treedepth(tree);
[to_tahmin(:,1,i),score,to_tahmin(:,2,i),cnum] = predict(tree,testing_x);
end

for i=1:ensmsay
    for j=1:tornsay
    depths(j,1,i)=floor((nodedepth(to_tahmin(j,2,i))/treedpth(i))*100);%karar�n derinli�inin bulundu�u a�ac�n derinli�ine oran� 
    depths(j,2,i)=100-depths(j,1,i);%yukar�lara g�venmek i�in
    end
end
%orjinal(derinli�e g�re a��rl�kland�rma yap�lmadan) y�ntemin
%tahmini-->"orjtahmin" yeni y�ntemin tahmini-->"drntahmin"
orjtahmin=zeros(tornsay,1);

%s�n�fland�rmada ortak tahmin(derinlik olmadan)
tahminsay=[1,sinifsay];
dogrutahmin=0;
for i=1:tornsay
    tahminsay=zeros(1,sinifsay);
    for j=1:ensmsay
        tahminsay(1,to_tahmin(i,1,j))=tahminsay(1,to_tahmin(i,1,j))+1;
    end
    [encok,orjtahmin(i,1)]=max(tahminsay);
    if orjtahmin(i,1)==testing_y(i,1)
        dogrutahmin=dogrutahmin+1;
    end
end
%s�n�fland�rma ba�ar�s�
basari=(dogrutahmin/tornsay)*100;

%s�n�fland�rmada ortak tahmin(derinlik hesaba kat�larak)
drntahmin=zeros(tornsay,2);
dogrutahmin2=0;
dogrutahmin3=0;
for i=1:tornsay
    tahminsay2=zeros(2,sinifsay);
    for j=1:ensmsay
        %1. yakla��m--> derinde verilen karara g�venilmez-->basari2
        %2. yakla��m--> derinde verilen karara g�venilir-->basari3
        tahminsay2(1,to_tahmin(i,1,j))=tahminsay2(1,to_tahmin(i,1,j))+depths(i,1,j);
        tahminsay2(2,to_tahmin(i,1,j))=tahminsay2(2,to_tahmin(i,1,j))+depths(i,2,j);%yukar�lara g�ven       
    end
    [encok2,drntahmin(i,1)]=max(tahminsay2(1,:));
    [encok3,drntahmin(i,2)]=max(tahminsay2(2,:));
    if drntahmin(i,1)==testing_y(i,1)
        dogrutahmin2=dogrutahmin2+1;
    end
    if drntahmin(i,2)==testing_y(i,1)%yukar�lara g�ven
        dogrutahmin3=dogrutahmin3+1;
    end
end
%derinli�e g�re verilen kararlarda s�n�fland�rma ba�ar�s�
basari2=(dogrutahmin2/tornsay)*100;
basari3=(dogrutahmin3/tornsay)*100;
basaritotal=[basari basari3];