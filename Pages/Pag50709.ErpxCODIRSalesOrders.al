page 50709 "Erpx CODIR Orders"
{
    Caption = 'CODIR Orders';
    PageType = List;
    SourceTable = "Sales Header";
    SourceTableView = where("Document Type" = filter(Order));
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("ErpX Job No."; Rec."ErpX Job No.")
                {
                    ApplicationArea = All;
                }
                field(Abbreviation; Rec.Abbreviation)
                {
                    ApplicationArea = All;
                }
                field("Erpx Job City"; Rec."Erpx Job City")
                {
                    ApplicationArea = All;
                }
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        SalesOrder: Record "Sales Header";
                    begin
                        SalesOrder.Reset();
                        SalesOrder.SetRange("Document Type", SalesOrder."Document Type"::Order);
                        SalesOrder.SetRange("No.", Rec."No.");
                        page.Run(Page::"Sales Order", SalesOrder);
                    end;

                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;
                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                }
                field("Erpx Document Type"; Rec."Erpx Document Type")
                {
                    ApplicationArea = All;
                }
                field("Erpx Total Amount HT"; Rec."Erpx Total Amount HT")
                {
                    ApplicationArea = All;
                }
                field("Erpx Total Amount Invoiced HT"; Rec."Erpx Total Amount Invoiced HT")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        Linepaymentplan: Record "Erpx Line payment plan";
                    begin
                        Linepaymentplan.Reset();
                        Linepaymentplan.SetRange("Erpx Document Type", Linepaymentplan."Erpx Document Type"::Order);
                        Linepaymentplan.SetRange("Erpx Document No.", Rec."No.");
                        Page.Run(Page::"Erpx Line Payement Plan", Linepaymentplan);
                    end;
                }
                field("Erpx % Invoiced"; Rec."Erpx % Invoiced")
                {
                    ApplicationArea = All;
                }
                field("Erpx Balance HT"; Rec."Erpx Balance HT")
                {
                    ApplicationArea = All;
                }

                field("Erpx Other Fees"; Rec."Erpx Other Fees")
                {
                    ApplicationArea = All;
                }
                field("Erpx Fee Amount HT"; Rec."Erpx Fee Amount HT")
                {
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnOpenPage()
    var      
        salesHeader: Record "Sales Header";
    begin
        salesHeader.Reset();
        salesHeader.SetRange("Document Type", salesHeader."Document Type"::Order);
        salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
        salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
        salesHeader."Erpx Document Type"::"Advancement amendment");
        salesHeader.SetFilter("ErpX Job No.", '<>%1', '');
        if salesHeader.FindFirst() then
            repeat
                salesHeader.CalculSalesHeader(salesHeader);                
            until salesHeader.Next() = 0;
    end;



}
