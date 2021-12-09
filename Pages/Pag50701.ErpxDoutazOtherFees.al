page 50701 "ErpxDoutaz Other Fees"
{
    Caption = 'Other Fees';
    PageType = List;
    SourceTable = "ErpxDoutaz Other fees";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                }
                field("Amount HT"; Rec."Amount HT")
                {
                    ApplicationArea = All;
                }
                field("Amount Include VAT"; Rec."Amount Include VAT")
                {
                    ApplicationArea = All;
                }

            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        rec."Line No." := rec.GetNextLineNo(xRec, BelowxRec);
    end;

    trigger OnClosePage()
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
        salesHeader.SetRange("No.", Rec."Document No.");
        if salesHeader.FindFirst() then begin
            if job.Get(salesHeader."ErpX Job No.") then begin
                job.CalcSalesHeader(job."No.");
                job.calcJob(job."No.");
            end;
        end;
    end;
}
