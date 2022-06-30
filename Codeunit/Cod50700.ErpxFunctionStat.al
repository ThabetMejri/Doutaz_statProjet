codeunit 50700 "ErpxFunctionStat"
{
    EventSubscriberInstance = StaticAutomatic;
    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterValidateEvent', 'Erpx Document Type', True, True)]
    local procedure ErpxStatOnAfterValidateJobNo(CurrFieldNo: Integer; var Rec: Record "Sales Header"; var xRec: Record "Sales Header")
    var
        OrderProgress: Record "Erpx Doutaz Order Progress";
        JobProgress: Record "Erpx Doutaz Job Progress";
    begin
        if Rec."Document Type" <> Rec."Document Type"::Order then
            exit;
        if (Rec."Erpx Document Type" = Rec."Erpx Document Type"::"Contract Hours") or (Rec."Erpx Document Type" = Rec."Erpx Document Type"::"Contract Payment plan") or
        (Rec."Erpx Document Type" = Rec."Erpx Document Type"::"Hours amendment") or (Rec."Erpx Document Type" = Rec."Erpx Document Type"::"Payment plan amendment") or (Rec."Erpx Document Type" = Rec."Erpx Document Type"::"Progress contract") or
         (Rec."Erpx Document Type" = Rec."Erpx Document Type"::"Advancement amendment") then begin
            JobProgress.Reset();
            JobProgress.SetRange("Job No.", Rec."ErpX Job No.");
            if JobProgress.FindFirst() then
                    repeat
                        OrderProgress.Reset();
                        OrderProgress.SetRange("Document Type", Rec."Document Type");
                        OrderProgress.SetRange("No.", Rec."No.");
                        OrderProgress.SetRange(Change, JobProgress.Change);
                        if not OrderProgress.FindFirst() then begin
                            OrderProgress.Init();
                            OrderProgress.TransferFields(JobProgress);
                            OrderProgress."Document Type" := Rec."Document Type";
                            OrderProgress."No." := Rec."No.";
                            OrderProgress.Insert();
                        end;
                    until JobProgress.Next() = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterModifyEvent', '', true, false)]
    local procedure ErpxStatSalesLineOnafterModify(var xRec: Record "Sales Line"; var Rec: Record "Sales Line")
    var
        DetailContrat: Record "Erpx Contract Detail";
        SalesHeader: Record "Sales Header";
        OrderProgress: Record "Erpx Doutaz Order Progress";
        JobProgress: Record "Erpx Doutaz Job Progress";
        OrderProgress2: Record "Erpx Doutaz Order Progress";
        Avancement: array[10] of Decimal;
        TauxFG: array[10] of Decimal;
        job: Record Job;
    begin
        if Rec."Line Amount" <> xRec."Line Amount" then begin
            // ErpxContractDetail.Reset();
            // ErpxContractDetail.SetRange("Document Type", Rec."Document Type");
            // ErpxContractDetail.SetRange("Document No.", Rec."Document No.");
            // ErpxContractDetail.SetRange("Sales Line No.", Rec."Line No.");
            // ErpxContractDetail.SetRange(Type, ErpxContractDetail.Type::Prestation);
            // ErpxContractDetail.SetFilter("Valeur %", '<>0');
            // if ErpxContractDetail.FindFirst() then
            //     repeat
            //         ErpxContractDetail.Validate("Valeur %");
            //         ErpxContractDetail.Modify();
            //     until ErpxContractDetail.Next() = 0;
        end;
        SalesHeader.Reset();
        SalesHeader.SetRange("Document Type", Rec."Document Type");
        SalesHeader.SetRange("No.", Rec."Document No.");
        salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
        salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
        salesHeader."Erpx Document Type"::"Advancement amendment");
        if SalesHeader.FindFirst() then begin
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
            JobProgress.Reset();
            JobProgress.SetRange("Job No.", SalesHeader."ErpX Job No.");
            if JobProgress.FindFirst() then
                    repeat
                        OrderProgress.Reset();
                        OrderProgress.SetRange("Document Type", SalesHeader."Document Type");
                        OrderProgress.SetRange("No.", SalesHeader."No.");
                        OrderProgress.SetRange(Change, JobProgress.Change);
                        if not OrderProgress.FindFirst() then begin
                            OrderProgress.Init();
                            OrderProgress.TransferFields(JobProgress);
                            OrderProgress."Document Type" := SalesHeader."Document Type";
                            OrderProgress."No." := SalesHeader."No.";
                            OrderProgress."Order Amount HT" := salesHeader."Erpx Total Amount HT";
                            OrderProgress.Insert();
                        end
                    until JobProgress.Next() = 0;
            if OrderProgress.FindLast() then begin
                if OrderProgress.Change = 0 then begin
                    OrderProgress."Amount HT" := SalesHeader."Erpx Fee Amount HT" * OrderProgress."% Overhead Rate" / 100 * OrderProgress."% Job Progress" / 100;
                    OrderProgress."Order Amount HT" := salesHeader."Erpx Total Amount HT";
                    OrderProgress.Modify();
                end;
                if OrderProgress.Change = 1 then begin
                    OrderProgress2.Reset();
                    OrderProgress2.SetRange("Document Type", SalesHeader."Document Type");
                    OrderProgress2.SetRange("No.", SalesHeader."No.");
                    OrderProgress2.SetRange(Change, 0);
                    if OrderProgress2.FindFirst() then
                        OrderProgress."Amount HT" := SalesHeader."Erpx Fee Amount HT" * (OrderProgress2."% Overhead Rate" / 100 * OrderProgress."% Job Progress" / 100 + OrderProgress."% Overhead Rate" / 100 * (OrderProgress2."% Job Progress" / 100 - OrderProgress."% Job Progress" / 100));
                    OrderProgress."Order Amount HT" := salesHeader."Erpx Total Amount HT";
                    OrderProgress.Modify();
                end;
                if OrderProgress.Change = 2 then begin
                    OrderProgress2.Reset();
                    OrderProgress2.SetRange("Document Type", SalesHeader."Document Type");
                    OrderProgress2.SetRange("No.", SalesHeader."No.");
                    OrderProgress2.SetRange(Change, 0);
                    if OrderProgress2.FindFirst() then begin
                        Avancement[1] := OrderProgress2."% Job Progress";
                        TauxFG[1] := OrderProgress2."% Overhead Rate";
                    end;
                    OrderProgress2.Reset();
                    OrderProgress2.SetRange("Document Type", SalesHeader."Document Type");
                    OrderProgress2.SetRange("No.", SalesHeader."No.");
                    OrderProgress2.SetRange(Change, 1);
                    if OrderProgress2.FindFirst() then begin
                        Avancement[2] := OrderProgress2."% Job Progress";
                        TauxFG[2] := OrderProgress2."% Overhead Rate";
                    end;
                    OrderProgress."Amount HT" := SalesHeader."Erpx Fee Amount HT" * (TauxFG[1] / 100 * Avancement[2] / 100 + TauxFG[2] / 100 * (OrderProgress."% Job Progress" / 100 - Avancement[2] / 100) + OrderProgress."% Overhead Rate" / 100 * (Avancement[1] / 100 - OrderProgress."% Job Progress" / 100));
                    OrderProgress."Order Amount HT" := salesHeader."Erpx Total Amount HT";
                    OrderProgress.Modify();
                end;
                if OrderProgress.Change = 3 then begin
                    OrderProgress2.Reset();
                    OrderProgress2.SetRange("Document Type", SalesHeader."Document Type");
                    OrderProgress2.SetRange("No.", SalesHeader."No.");
                    OrderProgress2.SetRange(Change, 0);
                    if OrderProgress2.FindFirst() then begin
                        Avancement[1] := OrderProgress2."% Job Progress";
                        TauxFG[1] := OrderProgress2."% Overhead Rate";
                    end;
                    OrderProgress2.Reset();
                    OrderProgress2.SetRange("Document Type", SalesHeader."Document Type");
                    OrderProgress2.SetRange("No.", SalesHeader."No.");
                    OrderProgress2.SetRange(Change, 1);
                    if OrderProgress2.FindFirst() then begin
                        Avancement[2] := OrderProgress2."% Job Progress";
                        TauxFG[2] := OrderProgress2."% Overhead Rate";
                    end;
                    OrderProgress2.Reset();
                    OrderProgress2.SetRange("Document Type", SalesHeader."Document Type");
                    OrderProgress2.SetRange("No.", SalesHeader."No.");
                    OrderProgress2.SetRange(Change, 2);
                    if OrderProgress2.FindFirst() then begin
                        Avancement[3] := OrderProgress2."% Job Progress";
                        TauxFG[3] := OrderProgress2."% Overhead Rate";
                    end;
                    OrderProgress."Order Amount HT" := salesHeader."Erpx Total Amount HT";
                    OrderProgress."Amount HT" := SalesHeader."Erpx Fee Amount HT" * (TauxFG[1] / 100 * Avancement[2] / 100 + TauxFG[2] / 100 * (Avancement[3] / 100 - Avancement[2] / 100) + TauxFG[3] / 100 * (OrderProgress."% Job Progress" / 100 - Avancement[3] / 100) + OrderProgress."% Overhead Rate" / 100 * (Avancement[1] / 100 - OrderProgress."% Job Progress" / 100));
                    OrderProgress.Modify();
                end;

                SalesHeader.CalcFields("Erpx General Expenses Fees");
                if job.Get(salesHeader."ErpX Job No.") then begin
                    job.CalcFields("Erpx % General Expenses Fees");
                    salesHeader."Erpx Overheads Desired Profit" := salesHeader."Erpx Fee Amount HT" * job."Erpx % Desired Benefit" / 100 + SalesHeader."Erpx General Expenses Fees";
                    SalesHeader.Modify();
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Job, 'OnAfterValidateEvent', 'Erpx % Desired Benefit', True, True)]
    local procedure ErpxStatOnAfterValidateEventDesiredBenefit(CurrFieldNo: Integer; var Rec: Record Job; var xRec: Record Job)
    var
    begin
        if (Rec."Erpx % Desired Benefit" <> xRec."Erpx % Desired Benefit") then begin
            Rec.CalcSalesHeader(rec."No.");
            Rec.CalcFields("Erpx Fee Amount HT", "Erpx Overheads Desired Profit", "Erpx Fees HT Used", "Erpx Hourly Fees Used");
            Rec."Erpx Fees HT at Disposal" := Rec."Erpx Fee Amount HT" - Rec."Erpx Overheads Desired Profit";
            Rec."Erpx Fees HT Balance Available" := Rec."Erpx Fees HT at Disposal" - Rec."Erpx Fees HT Used";
            if Rec."Erpx Average Fees" <> 0 then
                Rec."Erpx Hourly Fees Available" := Rec."Erpx Fees HT at Disposal" / Rec."Erpx Average Fees"
            else
                Rec."Erpx Hourly Fees Available" := 0;
            Rec."Erpx Hour fees Bal. Disposal" := Rec."Erpx Hourly Fees Available" - Rec."Erpx Hourly Fees Used";
            Rec."Erpx Desired Benefit HT" := Rec."Erpx Fee Amount HT" * Rec."Erpx % Desired Benefit" / 100;
            Rec."Erpx Risk and Chance HT" := Rec."Erpx Fees HT Balance Available";
            Rec."Erpx Benefit Forecast" := Rec."Erpx Desired Benefit HT" + Rec."Erpx Risk and Chance HT";
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::Job, 'OnAfterValidateEvent', 'Erpx Average Fees', True, True)]
    local procedure ErpxStatOnAfterValidateEventAverageFees(CurrFieldNo: Integer; var Rec: Record Job; var xRec: Record Job)
    var
    begin
        if (Rec."Erpx Average Fees" <> xRec."Erpx Average Fees") then begin
            Rec.CalcSalesHeader(rec."No.");
            Rec.CalcFields("Erpx Fee Amount HT", "Erpx Overheads Desired Profit", "Erpx Fees HT Used", "Erpx Hourly Fees Used");
            Rec."Erpx Fees HT at Disposal" := Rec."Erpx Fee Amount HT" - Rec."Erpx Overheads Desired Profit";
            Rec."Erpx Fees HT Balance Available" := Rec."Erpx Fees HT at Disposal" - Rec."Erpx Fees HT Used";
            if Rec."Erpx Average Fees" <> 0 then
                Rec."Erpx Hourly Fees Available" := Rec."Erpx Fees HT at Disposal" / Rec."Erpx Average Fees"
            else
                Rec."Erpx Hourly Fees Available" := 0;
            Rec."Erpx Hour fees Bal. Disposal" := Rec."Erpx Hourly Fees Available" - Rec."Erpx Hourly Fees Used";
            Rec."Erpx Desired Benefit HT" := Rec."Erpx Fee Amount HT" * Rec."Erpx % Desired Benefit" / 100;
            Rec."Erpx Risk and Chance HT" := Rec."Erpx Fees HT Balance Available";
            Rec."Erpx Benefit Forecast" := Rec."Erpx Desired Benefit HT" + Rec."Erpx Risk and Chance HT";
        end;

    end;

    procedure UpdateRateHoursEmplyee(var RatehoursHeader: Record "Erpx Doutaz Rate hours Header")
    begin
        RatehoursHeader.CalcFields("Total annual social charges");
        RatehoursHeader.Validate(RatehoursHeader."Total annual employer charges", RatehoursHeader."Total annual social charges" + RatehoursHeader."Salary Amount Annually");
        RatehoursHeader.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Erpx Doutaz Rate hours Line", 'OnAfterModifyEvent', '', True, True)]
    local procedure ErpxOnAfterModifyEventRateHoursLine(RunTrigger: Boolean; var Rec: Record "Erpx Doutaz Rate hours Line"; var xRec: Record "Erpx Doutaz Rate hours Line")
    var
        FunctionStat: Codeunit "ErpxFunctionStat";
        RatehoursHeader: Record "Erpx Doutaz Rate hours Header";
    begin
        RatehoursHeader.Get(rec."Employee No.");
        FunctionStat.UpdateRateHoursEmplyee(RatehoursHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Erpx Doutaz Rate hours Header", 'OnAfterInsertEvent', '', True, True)]
    local procedure ErpxOnAfterModifyEventRateHoursHeader(var Rec: Record "Erpx Doutaz Rate hours Header")
    begin
        UpdateRateHoursEmplyee(Rec);
        rec.Modify();
    end;

    [EventSubscriber(ObjectType::Table, Database::"Erpx Doutaz Planning Entries", 'OnAfterValidateEvent', 'Resource No.', true, true)]
    local procedure ErpxOnAfterValidateEventPlanningEntriesResourceNo(var Rec: Record "Erpx Doutaz Planning Entries"; var xRec: Record "Erpx Doutaz Planning Entries")
    var
        RatehoursHeader: Record "Erpx Doutaz Rate hours Header";
    begin
        if RatehoursHeader.Get(rec."Resource No.") then begin
            Rec."Unit cost" := RatehoursHeader."Net hourly rate with FG";            
            Rec."Total cost" := Rec.Quantity * RatehoursHeader."Net hourly rate with FG";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Erpx Doutaz Planning Entries", 'OnAfterValidateEvent', 'Quantity', true, true)]
    local procedure ErpxOnAfterValidateEventPlanningEntriesQuantity(var Rec: Record "Erpx Doutaz Planning Entries"; var xRec: Record "Erpx Doutaz Planning Entries")
    var
        RatehoursHeader: Record "Erpx Doutaz Rate hours Header";
    begin
        if RatehoursHeader.Get(rec."Resource No.") then begin
            Rec."Unit cost" := RatehoursHeader."Net hourly rate with FG";
            Rec."Total cost" := Rec.Quantity * RatehoursHeader."Net hourly rate with FG";
        end;
    end;

}
