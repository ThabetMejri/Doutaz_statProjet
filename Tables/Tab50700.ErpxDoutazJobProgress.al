table 50700 "Erpx Doutaz Job Progress"
{
    Caption = 'Job Progress';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Job No."; Code[20])
        {
            Caption = 'Job No.';
            DataClassification = CustomerContent;
            TableRelation = Job."No.";
        }
        field(2; Change; Integer)
        {
            Caption = 'Change';
            MaxValue = 3;
            MinValue = 0;
            DataClassification = ToBeClassified;
        }
        field(3; "% Overhead Rate"; Decimal)
        {
            Caption = '% Overhead Rate';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
        }
        field(4; "% Job Progress"; Decimal)
        {
            Caption = '% Job Progress';
            DataClassification = ToBeClassified;
            MaxValue = 100;
            MinValue = 0;
            trigger OnValidate()
            begin
                TestField(Change);
            end;
        }
        field(100; "Last Change"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max("Erpx Doutaz Job Progress".Change where("Job No." = field("Job No.")));
            Editable = false;
        }

    }
    keys
    {
        key(PK; "Job No.", Change)
        {
            Clustered = true;
        }
    }

    trigger OnModify()
    begin
        CalcFields("Last Change");
        if Rec.Change < Rec."Last Change" then Error(MsgError);
        CalculSalesOrder(Rec."Job No.", true);


    end;

    trigger OnDelete()
    begin
        CalcFields("Last Change");
        if Rec.Change < Rec."Last Change" then Error(MsgError);

        SalesHeader.Reset();
        SalesHeader.SetRange("ErpX Job No.", Rec."Job No.");
        salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
        salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
        salesHeader."Erpx Document Type"::"Advancement amendment");
        if SalesHeader.FindFirst() then begin
            repeat
                OrderProgress.Reset();
                OrderProgress.SetRange("Document Type", SalesHeader."Document Type");
                OrderProgress.SetRange("No.", SalesHeader."No.");
                OrderProgress.SetRange(Change, Rec.Change);
                if OrderProgress.FindFirst() then
                    OrderProgress.Delete();
            until salesHeader.Next() = 0;
            CalculSalesOrder(Rec."Job No.", false);

        end;
    end;

    trigger OnInsert()
    begin
        if Rec.Change = 0 then
            rec."% Job Progress" := 100;

        CalculSalesOrder(Rec."Job No.", true);
    end;


    var
        JobProgress: Record "Erpx Doutaz Job Progress";
        OrderProgress: Record "Erpx Doutaz Order Progress";
        OrderProgress2: Record "Erpx Doutaz Order Progress";
        SalesHeader: Record "Sales Header";
        DetailContrat: Record "Erpx Contract Detail";
        job: Record Job;
        LastProgress: Integer;
        MsgError: Label 'You can change only the last line.';
        Avancement: array[4] of Decimal;
        TauxFG: array[4] of Decimal;

    procedure CalculSalesOrder(JobNo: Code[20]; UpdateOrderProgress: Boolean)
    begin
        SalesHeader.Reset();
        SalesHeader.SetRange("ErpX Job No.", JobNo);
        salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
        salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
        salesHeader."Erpx Document Type"::"Advancement amendment");
        if SalesHeader.FindFirst() then begin
            repeat
                if (salesHeader."Erpx Document Type" = salesHeader."Erpx Document Type"::"Contract Hours") or (salesHeader."Erpx Document Type" = salesHeader."Erpx Document Type"::"Hours amendment") then begin
                    if salesHeader."Erpx FA Statistics" then begin
                        DetailContrat.Reset();
                        DetailContrat.SetRange("Document No.", salesHeader."No.");
                        DetailContrat.SetRange("Document Type", salesHeader."Document Type");
                        DetailContrat.CalcSums("Amount Invoiced");
                        salesHeader."Erpx Total Amount HT" := DetailContrat."Amount Invoiced";
                    end
                    else begin
                        salesHeader.CalcFields(Amount);
                        salesHeader."Erpx Total Amount HT" := salesHeader.Amount;
                    end;
                end
                else begin
                    salesHeader.CalcFields(Amount);
                    salesHeader."Erpx Total Amount HT" := salesHeader.Amount;
                end;
                salesHeader.CalcFields("Erpx Other Fees");
                salesHeader."Erpx Fee Amount HT" := salesHeader."Erpx Total Amount HT" - salesHeader."Erpx Other Fees";
                salesHeader.Modify();
                if UpdateOrderProgress then
                    CalculerOrderProgress(SalesHeader);

                SalesHeader.CalcFields("Erpx General Expenses Fees");
                if job.Get(salesHeader."ErpX Job No.") then
                    salesHeader."Erpx Overheads Desired Profit" := salesHeader."Erpx Fee Amount HT" * job."Erpx % Desired Benefit" / 100 + SalesHeader."Erpx General Expenses Fees";

                salesHeader.Modify();
            until SalesHeader.Next() = 0;
            job.calcJob(Rec."Job No.");
        end;
    end;

    procedure CalculerOrderProgress(LSalesHeader: Record "Sales Header")
    begin

        OrderProgress.Reset();
        OrderProgress.SetRange("Document Type", LSalesHeader."Document Type");
        OrderProgress.SetRange("No.", LSalesHeader."No.");
        OrderProgress.SetRange(Change, Rec.Change);
        if not OrderProgress.FindFirst() then begin
            OrderProgress.Init();
            OrderProgress.TransferFields(Rec);
            OrderProgress."Document Type" := LSalesHeader."Document Type";
            OrderProgress."No." := LSalesHeader."No.";
            OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
            OrderProgress.Insert();
        end
        else begin
            OrderProgress.TransferFields(Rec);
            OrderProgress."Document Type" := LSalesHeader."Document Type";
            OrderProgress."No." := LSalesHeader."No.";
            OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
            OrderProgress.Modify();
        end;
        if OrderProgress.Change = 0 then begin
            OrderProgress."Amount HT" := LSalesHeader."Erpx Fee Amount HT" * OrderProgress."% Overhead Rate" / 100 * OrderProgress."% Job Progress" / 100;
            OrderProgress.Modify();
        end;
        if OrderProgress.Change = 1 then begin
            OrderProgress2.Reset();
            OrderProgress2.SetRange("Document Type", LSalesHeader."Document Type");
            OrderProgress2.SetRange("No.", LSalesHeader."No.");
            OrderProgress2.SetRange(Change, 0);
            if OrderProgress2.FindFirst() then
                OrderProgress."Amount HT" := LSalesHeader."Erpx Fee Amount HT" * (OrderProgress2."% Overhead Rate" / 100 * OrderProgress."% Job Progress" / 100 + OrderProgress."% Overhead Rate" / 100 * (OrderProgress2."% Job Progress" / 100 - OrderProgress."% Job Progress" / 100));
            OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
            OrderProgress.Modify();
        end;
        if OrderProgress.Change = 2 then begin
            OrderProgress2.Reset();
            OrderProgress2.SetRange("Document Type", LSalesHeader."Document Type");
            OrderProgress2.SetRange("No.", LSalesHeader."No.");
            OrderProgress2.SetRange(Change, 0);
            if OrderProgress2.FindFirst() then begin
                Avancement[1] := OrderProgress2."% Job Progress";
                TauxFG[1] := OrderProgress2."% Overhead Rate";
            end;
            OrderProgress2.Reset();
            OrderProgress2.SetRange("Document Type", LSalesHeader."Document Type");
            OrderProgress2.SetRange("No.", LSalesHeader."No.");
            OrderProgress2.SetRange(Change, 1);
            if OrderProgress2.FindFirst() then begin
                Avancement[2] := OrderProgress2."% Job Progress";
                TauxFG[2] := OrderProgress2."% Overhead Rate";
            end;
            OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
            OrderProgress."Amount HT" := LSalesHeader."Erpx Fee Amount HT" * (TauxFG[1] / 100 * Avancement[2] / 100 + TauxFG[2] / 100 * (OrderProgress."% Job Progress" / 100 - Avancement[2] / 100) + OrderProgress."% Overhead Rate" / 100 * (Avancement[1] / 100 - OrderProgress."% Job Progress" / 100));
            OrderProgress.Modify();
        end;
        if OrderProgress.Change = 3 then begin
            OrderProgress2.Reset();
            OrderProgress2.SetRange("Document Type", LSalesHeader."Document Type");
            OrderProgress2.SetRange("No.", LSalesHeader."No.");
            OrderProgress2.SetRange(Change, 0);
            if OrderProgress2.FindFirst() then begin
                Avancement[1] := OrderProgress2."% Job Progress";
                TauxFG[1] := OrderProgress2."% Overhead Rate";
            end;
            OrderProgress2.Reset();
            OrderProgress2.SetRange("Document Type", LSalesHeader."Document Type");
            OrderProgress2.SetRange("No.", LSalesHeader."No.");
            OrderProgress2.SetRange(Change, 1);
            if OrderProgress2.FindFirst() then begin
                Avancement[2] := OrderProgress2."% Job Progress";
                TauxFG[2] := OrderProgress2."% Overhead Rate";
            end;
            OrderProgress2.Reset();
            OrderProgress2.SetRange("Document Type", LSalesHeader."Document Type");
            OrderProgress2.SetRange("No.", LSalesHeader."No.");
            OrderProgress2.SetRange(Change, 2);
            if OrderProgress2.FindFirst() then begin
                Avancement[3] := OrderProgress2."% Job Progress";
                TauxFG[3] := OrderProgress2."% Overhead Rate";
            end;
            OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
            OrderProgress."Amount HT" := LSalesHeader."Erpx Fee Amount HT" * (TauxFG[1] / 100 * Avancement[2] / 100 + TauxFG[2] / 100 * (Avancement[3] / 100 - Avancement[2] / 100) + TauxFG[3] / 100 * (OrderProgress."% Job Progress" / 100 - Avancement[3] / 100) + OrderProgress."% Overhead Rate" / 100 * (Avancement[1] / 100 - OrderProgress."% Job Progress" / 100));
            OrderProgress.Modify();
        end;
    end;
}
