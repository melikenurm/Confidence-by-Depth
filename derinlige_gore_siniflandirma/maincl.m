[x,y]=arffoku('C:\Users\Melike Nur Mermer\Desktop\36uci\36uci\d159.arff');
[satir,sutun]=size(x);
tekrarsayi=10;
basaritotal=zeros(20,2);
i=1;
while i<=2*tekrarsayi
[eorn,torn]=crossval(satir,2);
%eorn{1,1}=1.foldun eðitim seti, eorn{1,2}=2.foldun eðitim seti
%datasetin yarýsý eðitim orneði yarýsý test
edata=eorn{1,1};
tdata=torn{1,1};
basaritotal(i,:)=odev2(edata,tdata);
i=i+1;
edata=eorn{1,2};
tdata=torn{1,2};
basaritotal(i,:)=odev2(edata,tdata);
i=i+1;
end
H=ttest2(basaritotal(:,1),basaritotal(:,2));