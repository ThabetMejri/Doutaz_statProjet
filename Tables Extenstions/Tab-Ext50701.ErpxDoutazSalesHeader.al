tableextension 50701 "ErpxDoutazSalesHeader" extends "Sales Header"
{
    fields
    {
        field(50700; "Erpx Other Fees"; Decimal)
        {
            Caption = 'Other Fees HT';
            FieldClass = FlowField;
            CalcFormula = sum("ErpxDoutaz Other fees"."Amount HT" where("Document No." = field("No."), "Document Type" = field("Document Type")));
            Editable = false;
        }
        field(50701; "Erpx FA Statistics"; Boolean)
        {
            Caption = 'FA Statistics';
            DataClassification = ToBeClassified;
        }
        field(50702; "Erpx Fee Amount HT"; Decimal)
        {
            Caption = 'Fee Amount HT';
            DataClassification = ToBeClassified;
        }
        field(50703; "Erpx Overheads Desired Profit"; Decimal)
        {
            Caption = 'Overheads And Desired Profit HT';
            DataClassification = ToBeClassified;
        }
        field(50704; "Erpx Total Amount HT"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Total Amount HT';
        }
        field(50709; "Erpx Desired Benefit HT"; Decimal)
        {
            Caption = 'Desired Benefit HT';
            DataClassification = CustomerContent;
        }
        field(50710; "Erpx General Expenses Fees"; Decimal)
        {
            Caption = 'General Expenses Fees';
            FieldClass = FlowField;
            CalcFormula = lookup("Erpx Doutaz order Progress"."Amount HT" where("Document Type" = field("Document Type"), "No." = field("No."), Change = field("Erpx Last change")));
            Editable = false;
        }
        field(50711; "Erpx Last Change"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max("Erpx Doutaz order Progress".Change where("Document Type" = field("Document Type"), "No." = field("No.")));
            Editable = false;
        }
        field(50712; "Erpx Total Amount Invoiced HT"; Decimal)
        {
            Caption = 'Total Amount Invoiced HT';
            DataClassification = CustomerContent;
        }
        field(50713; "Erpx % Invoiced"; Decimal)
        {
            Caption = '% Invoiced';
            DataClassification = CustomerContent;
        }
        field(50714; "Erpx Balance HT"; Decimal)
        {
            Caption = 'Total Balance HT';
            DataClassification = CustomerContent;
        }
    }
    procedure CalculSalesHeader(var salesheader: Record "Sales Header")
    var
        job: Record Job;
        DetailContrat: Record "Erpx Contract Detail";
        Linepaymentplan: Record "Erpx Line payment plan";
    begin
        job.Get(salesheader."ErpX Job No.");

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
        salesHeader.CalcFields("Erpx Other Fees", "Erpx General Expenses Fees");
        salesHeader."Erpx Fee Amount HT" := salesHeader."Erpx Total Amount HT" - salesHeader."Erpx Other Fees";
        salesHeader.Modify();
        CalcOrderProgress(salesHeader);
        salesHeader."Erpx Overheads Desired Profit" := salesHeader."Erpx Fee Amount HT" * job."Erpx % Desired Benefit" / 100 + salesHeader."Erpx General Expenses Fees";
        salesHeader.Modify();
        Linepaymentplan.Reset();
        Linepaymentplan.SetRange("Erpx Document Type", SalesHeader."Document Type");
        Linepaymentplan.SetRange("Erpx Document No.", SalesHeader."No.");
        if Linepaymentplan.FindFirst() then begin
            SalesHeader."Erpx Total Amount Invoiced HT" := 0;
            repeat
                Linepaymentplan.CalcFields("Invoice Amount");

                if Linepaymentplan."Erpx Reprise" then
                    SalesHeader."Erpx Total Amount Invoiced HT" += Linepaymentplan."Reprise Prepayment Amount HT "
                else
                    SalesHeader."Erpx Total Amount Invoiced HT" += Linepaymentplan."Invoice Amount";

            until Linepaymentplan.Next() = 0;
            if SalesHeader."Erpx Total Amount HT" <> 0 then
                SalesHeader."Erpx % Invoiced" := SalesHeader."Erpx Total Amount Invoiced HT" / SalesHeader."Erpx Total Amount HT" * 100
            else
                SalesHeader."Erpx % Invoiced" := 0;
            SalesHeader."Erpx Balance HT" := SalesHeader."Erpx Total Amount HT" - SalesHeader."Erpx Total Amount Invoiced HT";
            SalesHeader.Modify();
        end;
    end;



    procedure CalcOrderProgress(LsalesHeader: Record "Sales Header")
    var
        OrderProgress: Record "Erpx Doutaz Order Progress";
        JobProgress: Record "Erpx Doutaz Job Progress";
        OrderProgress2: Record "Erpx Doutaz Order Progress";
        Avancement: array[10] of Decimal;
        TauxFG: array[10] of Decimal;
        job: Record Job;
    begin
        JobProgress.Reset();
        JobProgress.SetRange("Job No.", LsalesHeader."ErpX Job No.");
        if JobProgress.FindFirst() then
            repeat
                OrderProgress.Reset();
                OrderProgress.SetRange("Document Type", LsalesHeader."Document Type");
                OrderProgress.SetRange("No.", LsalesHeader."No.");
                OrderProgress.SetRange(Change, JobProgress.Change);
                if not OrderProgress.FindFirst() then begin
                    OrderProgress.Init();
                    OrderProgress.TransferFields(JobProgress);
                    OrderProgress."Document Type" := LsalesHeader."Document Type";
                    OrderProgress."No." := LsalesHeader."No.";
                    OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
                    OrderProgress.Insert();
                end
            until JobProgress.Next() = 0;
        if OrderProgress.FindLast() then begin
            if OrderProgress.Change = 0 then begin
                OrderProgress."Amount HT" := LsalesHeader."Erpx Fee Amount HT" * OrderProgress."% Overhead Rate" / 100 * OrderProgress."% Job Progress" / 100;
                OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
                OrderProgress.Modify();
            end;
            if OrderProgress.Change = 1 then begin
                OrderProgress2.Reset();
                OrderProgress2.SetRange("Document Type", LsalesHeader."Document Type");
                OrderProgress2.SetRange("No.", LsalesHeader."No.");
                OrderProgress2.SetRange(Change, 0);
                if OrderProgress2.FindFirst() then
                    OrderProgress."Amount HT" := LsalesHeader."Erpx Fee Amount HT" * (OrderProgress2."% Overhead Rate" / 100 * OrderProgress."% Job Progress" / 100 + OrderProgress."% Overhead Rate" / 100 * (OrderProgress2."% Job Progress" / 100 - OrderProgress."% Job Progress" / 100));
                OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
                OrderProgress.Modify();
            end;
            if OrderProgress.Change = 2 then begin
                OrderProgress2.Reset();
                OrderProgress2.SetRange("Document Type", LsalesHeader."Document Type");
                OrderProgress2.SetRange("No.", LsalesHeader."No.");
                OrderProgress2.SetRange(Change, 0);
                if OrderProgress2.FindFirst() then begin
                    Avancement[1] := OrderProgress2."% Job Progress";
                    TauxFG[1] := OrderProgress2."% Overhead Rate";
                end;
                OrderProgress2.Reset();
                OrderProgress2.SetRange("Document Type", LsalesHeader."Document Type");
                OrderProgress2.SetRange("No.", LsalesHeader."No.");
                OrderProgress2.SetRange(Change, 1);
                if OrderProgress2.FindFirst() then begin
                    Avancement[2] := OrderProgress2."% Job Progress";
                    TauxFG[2] := OrderProgress2."% Overhead Rate";
                end;
                OrderProgress."Amount HT" := LsalesHeader."Erpx Fee Amount HT" * (TauxFG[1] / 100 * Avancement[2] / 100 + TauxFG[2] / 100 * (OrderProgress."% Job Progress" / 100 - Avancement[2] / 100) + OrderProgress."% Overhead Rate" / 100 * (Avancement[1] / 100 - OrderProgress."% Job Progress" / 100));
                OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
                OrderProgress.Modify();
            end;
            if OrderProgress.Change = 3 then begin
                OrderProgress2.Reset();
                OrderProgress2.SetRange("Document Type", LsalesHeader."Document Type");
                OrderProgress2.SetRange("No.", LsalesHeader."No.");
                OrderProgress2.SetRange(Change, 0);
                if OrderProgress2.FindFirst() then begin
                    Avancement[1] := OrderProgress2."% Job Progress";
                    TauxFG[1] := OrderProgress2."% Overhead Rate";
                end;
                OrderProgress2.Reset();
                OrderProgress2.SetRange("Document Type", LsalesHeader."Document Type");
                OrderProgress2.SetRange("No.", LsalesHeader."No.");
                OrderProgress2.SetRange(Change, 1);
                if OrderProgress2.FindFirst() then begin
                    Avancement[2] := OrderProgress2."% Job Progress";
                    TauxFG[2] := OrderProgress2."% Overhead Rate";
                end;
                OrderProgress2.Reset();
                OrderProgress2.SetRange("Document Type", LsalesHeader."Document Type");
                OrderProgress2.SetRange("No.", LsalesHeader."No.");
                OrderProgress2.SetRange(Change, 2);
                if OrderProgress2.FindFirst() then begin
                    Avancement[3] := OrderProgress2."% Job Progress";
                    TauxFG[3] := OrderProgress2."% Overhead Rate";
                end;
                OrderProgress."Order Amount HT" := LsalesHeader."Erpx Total Amount HT";
                OrderProgress."Amount HT" := LsalesHeader."Erpx Fee Amount HT" * (TauxFG[1] / 100 * Avancement[2] / 100 + TauxFG[2] / 100 * (Avancement[3] / 100 - Avancement[2] / 100) + TauxFG[3] / 100 * (OrderProgress."% Job Progress" / 100 - Avancement[3] / 100) + OrderProgress."% Overhead Rate" / 100 * (Avancement[1] / 100 - OrderProgress."% Job Progress" / 100));
                OrderProgress.Modify();
            end;
        end;
    end;    
}
