tableextension 50700 "ErpxDoutazJob" extends Job
{
    fields
    {
        field(50700; "Erpx % General Expenses Fees"; Decimal)
        {
            Caption = '% General Expenses Fees';
            FieldClass = FlowField;
            CalcFormula = lookup("Erpx Doutaz job Progress"."% Overhead Rate" where("Job No." = field("No."), Change = field("Erpx Last Progress")));
            Editable = false;
        }
        field(50701; "Erpx % Desired Benefit"; Decimal)
        {
            Caption = '% Desired Benefit ';
            DataClassification = CustomerContent;
        }
        field(50702; "Erpx Average Fees"; Decimal)
        {
            Caption = 'Average Fees';
            DataClassification = CustomerContent;
        }
        field(50703; "Erpx Fees HT at Disposal"; Decimal)
        {
            Caption = 'Fees HT at Disposal';
            DataClassification = CustomerContent;
        }
        field(50704; "Erpx Fees HT Used"; Decimal)
        {
            Caption = 'Fees HT Used';
            DataClassification = CustomerContent;
        }
        field(50705; "Erpx Fees HT Balance Available"; Decimal)
        {
            Caption = 'Fees HT Balance Available';
            DataClassification = CustomerContent;
        }
        field(50706; "Erpx Hour fees Bal. Disposal"; Decimal)
        {
            Caption = 'Hourly fees Balance at Disposal';
            DataClassification = CustomerContent;
        }
        field(50707; "Erpx Hourly Fees Available"; Decimal)
        {
            Caption = 'Hourly Fees Available';
            DataClassification = CustomerContent;
        }
        field(50708; "Erpx Hourly Fees Used"; Decimal)
        {
            Caption = 'Hourly Fees Used';
            DataClassification = CustomerContent;
        }
        field(50709; "Erpx Desired Benefit HT"; Decimal)
        {
            Caption = 'Desired Benefit HT';
            DataClassification = CustomerContent;
        }
        field(50710; "Erpx Risk and Chance HT"; Decimal)
        {
            Caption = 'Risk and Chance HT';
            DataClassification = CustomerContent;
        }
        field(50711; "Erpx Benefit Forecast"; Decimal)
        {
            Caption = 'Benefit Forecast';
            DataClassification = CustomerContent;
        }
        field(50712; "Erpx Last Progress"; Integer)
        {
            FieldClass = FlowField;
            CalcFormula = max("Erpx Doutaz Job Progress".Change where("Job No." = field("No.")));
            Editable = false;
        }
        field(50713; "Erpx Fee Amount HT"; Decimal)
        {
            Caption = 'Fee Amount HT';
            FieldClass = FlowField;
            CalcFormula = sum("Sales Header"."Erpx Fee Amount HT" where("ErpX Job No." = field("No.")));
            Editable = false;
        }
        field(50714; "Erpx Overheads Desired Profit"; Decimal)
        {
            Caption = 'Overheads And Desired Profit';
            CalcFormula = sum("Sales Header"."Erpx Overheads Desired Profit" where("ErpX Job No." = field("No.")));
            FieldClass = FlowField;
            Editable = false;
        }

    }
    procedure CalcSalesHeader(JobNo: Code[20])
    begin
        job.Get(JobNo);
        //job."Erpx Fee Amount HT" := 0;
        salesHeader.Reset();
        salesHeader.SetRange("ErpX Job No.", job."No.");
        salesHeader.SetRange("Erpx FA Statistics", true);
        salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
                            salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
                            salesHeader."Erpx Document Type"::"Advancement amendment");
        if salesHeader.FindFirst() then begin
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
                salesHeader.CalcFields("Erpx Other Fees", "Erpx General Expenses Fees");
                salesHeader."Erpx Fee Amount HT" := salesHeader."Erpx Total Amount HT" - salesHeader."Erpx Other Fees";
                salesHeader.Modify();
                CalcOrderProgress(salesHeader);
                salesHeader."Erpx Overheads Desired Profit" := salesHeader."Erpx Fee Amount HT" * job."Erpx % Desired Benefit" / 100 + salesHeader."Erpx General Expenses Fees";
                salesHeader.Modify();

            // job."Erpx Fee Amount HT" += salesHeader."Erpx Fee Amount HT";
            until salesHeader.Next() = 0;

        end;
        //job.Modify();
    end;

    procedure calcJob(JobNo: Code[20])
    begin
        job.Get(JobNo);
        job.CalcFields("Erpx Fee Amount HT", "Erpx Overheads Desired Profit");
        job."Erpx Fees HT at Disposal" := job."Erpx Fee Amount HT" - job."Erpx Overheads Desired Profit";
        job."Erpx Fees HT Balance Available" := job."Erpx Fees HT at Disposal" - job."Erpx Fees HT Used";
        if job."Erpx Average Fees" <> 0 then
            job."Erpx Hourly Fees Available" := job."Erpx Fees HT at Disposal" / job."Erpx Average Fees"
        else
            job."Erpx Hourly Fees Available" := 0;
        job."Erpx Hour fees Bal. Disposal" := job."Erpx Hourly Fees Available" - job."Erpx Hourly Fees Used";
        job."Erpx Desired Benefit HT" := job."Erpx Fee Amount HT" * job."Erpx % Desired Benefit" / 100;
        job."Erpx Risk and Chance HT" := job."Erpx Fees HT Balance Available";
        job."Erpx Benefit Forecast" := job."Erpx Desired Benefit HT" + job."Erpx Risk and Chance HT";

        job.Modify();
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

    var
        salesHeader: Record "Sales Header";
        job: Record Job;
        DetailContrat: Record "Erpx Contract Detail";
}
