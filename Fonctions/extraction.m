function Multi1 = extraction(chNbre,Cor,Nbre,seuil)
    % Channel 1
    Ext1 = [];
    k = 0;
    % Extraction : recherche de corrélations supérieures au seuil
    for i = 1:chNbre
        for j =(i+1):chNbre
            if Cor(i,j)>seuil
                k = k+1;
                Ext1(k,1) = i;
                Ext1(k,2) = j;
            end
        end
    end

    % Constition des multiplets
    n = size(Ext1);
    Nmulti = 1;
    PositionMul = 0;
    Mul1 = [Ext1(1,1) Ext1(1,2)];
    for i = 2:n(1)

        % Recherche d'un multi contenant Ext1(i,1)
        [rowA,colA] = find(Mul1==Ext1(i,1));
        [rowB,colB] = find(Mul1==Ext1(i,2));
        % Création nouveau multi ou positionnement sur celui existe de Ext1(i,1)
        if isempty(rowA) == 1
            if isempty(rowB) == 1
                Nmulti = Nmulti+1;
                PositionMul = Nmulti;
                Mul1(PositionMul,1) = Ext1(i,1);
                Mul1(PositionMul,2) = Ext1(i,2);
            else
                PositionMul = rowB;
                X = find(Mul1(PositionMul,:)==0);
                if isempty(X) == 1
                    Mul1(PositionMul,end+1) = Ext1(i,1);
                else
                    Mul1(PositionMul,X(1)) = Ext1(i,1);
                end
            end         
        else
            if isempty(rowB) == 1
                PositionMul = rowA;
                X = find(Mul1(PositionMul,:)==0);
                if isempty(X) == 1
                    Mul1(PositionMul,end+1) = Ext1(i,2);
                else
                    Mul1(PositionMul,X(1)) = Ext1(i,2);
                end 

            else
                if rowA(1) ~= rowB(1)
                    len0A = size(find(Mul1(rowA,:)==0));
                    lenxB = size(find(Mul1(rowB,:)~=0));
                    for a = (len0A(2)+1):lenxB(2)
                        Mul1(rowA,end+1) = 0;
                    end
                    xA = find(Mul1(rowA,:)==0);
                    for x = 1:lenxB(2)
                        Mul1(rowA,xA(x)) = Mul1(rowB,x);
                    end
                    Mul1(rowB,:) = [];
                end
            end 
        end 
    end

    % Suppression des zeros et trie croissant des multiplets
    len1 = size(Mul1);
    for i = 1:len1(1)
        Multi1{i} = Mul1(i,:);
        idx = Multi1{i}==0;
        Multi1{i}(idx) = []; 
        Multi1{i} = sort(Multi1{i});
    end
    len1 = size(Multi1);
    for i = len1(2):-1:1
        l = size(Multi1{i});
        if l(2)<Nbre
            Multi1(i) = [];
        end
    end
end

