pageextension 50702 "ErpxDoutazSalesOrderList" extends "Sales Order List"
{
    actions
    {
        addafter("Sales Reservation Avail.")
        {
            action(CODIR_ORDER)
            {
                Caption = 'CODIR Orders';
                RunObject = page "Erpx CODIR Orders";
                Promoted = true;
                ApplicationArea = all;
                PromotedCategory = "Report";
                Image = Statistics1099;
            }
        }
        modify("Sales Reservation Avail.")
        {
            Visible = false;
        }
    }

    trigger OnOpenPage()
    var
        salesHeader: Record "Sales Header";
        job: Record Job;
    begin
        salesHeader.Reset();
        salesHeader.SetRange("Document Type", salesHeader."Document Type"::Order);
        salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
        salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
        salesHeader."Erpx Document Type"::"Advancement amendment");
        salesHeader.SetFilter("ErpX Job No.", '<>%1', '');
        if salesHeader.FindFirst() then
            repeat
                if job.Get(salesHeader."ErpX Job No.") then begin
                    salesHeader.CalculSalesHeader(salesHeader);
                    job.calcJob(salesHeader."ErpX Job No.");
                end;
            until salesHeader.Next() = 0;
    end;

}
