pageextension 50702 ErpxDoutazSalesOrderList extends "Sales Order List"
{
    trigger OnOpenPage()
    var
        salesHeader: Record "Sales Header";
        DetailContrat: Record "Erpx Contract Detail";
        job: Record Job;
    begin
        salesHeader.Reset();
        salesHeader.SetRange("Document Type", salesHeader."Document Type"::Order);        
        salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
        salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
        salesHeader."Erpx Document Type"::"Advancement amendment");
        if salesHeader.FindFirst() then
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
                if job.Get(salesHeader."ErpX Job No.") then begin
                    job.CalcFields("Erpx % General Expenses Fees");
                    salesHeader."Erpx Overheads Desired Profit" := salesHeader."Erpx Fee Amount HT" * (job."Erpx % General Expenses Fees" + job."Erpx % Desired Benefit") / 100;
                end;
                salesHeader.Modify();
            until salesHeader.Next() = 0;
    end;
}
