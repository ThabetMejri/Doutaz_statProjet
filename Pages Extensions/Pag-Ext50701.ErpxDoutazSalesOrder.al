pageextension 50701 "ErpxDoutaz Sales Order" extends "Sales Order"
{
    layout
    {
        addafter(Abbreviation)
        {
            field("Erpx Other Fees"; rec."Erpx Other Fees")
            {
                ApplicationArea = all;
                trigger OnAssistEdit()
                var
                    OtherFees: Record "ErpxDoutaz Other fees";
                begin
                    OtherFees.Reset();
                    OtherFees.SetRange("Document No.", Rec."No.");
                    OtherFees.SetRange("Document Type", Rec."Document Type");
                    Page.Run(Page::"ErpxDoutaz Other Fees", OtherFees);
                end;
            }

        }
        addafter("Erpx Finished Contract")
        {
            field("Erpx FA Statistics"; rec."Erpx FA Statistics")
            {
                ApplicationArea = all;
            }
        }
        addbefore("Invoice Details")
        {
            group(Statistic)
            {
                Caption = 'Statistic';
                field("Erpx Total Amount HT"; rec."Erpx Total Amount HT")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Other Fees"; rec."Erpx Other Fees")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Erpx Fee Amount HT"; rec."Erpx Fee Amount HT")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Erpx Last Change"; rec."Erpx Last Change")
                {
                    ApplicationArea = All;
                }
                field("Erpx General Expenses Fees"; Rec."Erpx General Expenses Fees")
                {
                    ApplicationArea = All;
                }

                field("Erpx Overheads Desired Profit"; rec."Erpx Overheads Desired Profit")
                {
                    ApplicationArea = all;
                    Editable = false;
                }

            }
        }
    }
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
        salesHeader.SetRange("No.", Rec."No.");
        salesHeader.SetFilter("ErpX Job No.", '<>%1', '');
        if salesHeader.FindFirst() then begin
            if job.Get(salesHeader."ErpX Job No.") then begin
                job.CalcSalesHeader(job."No.");
                job.calcJob(job."No.");
            end;
        end;
    end;
}
