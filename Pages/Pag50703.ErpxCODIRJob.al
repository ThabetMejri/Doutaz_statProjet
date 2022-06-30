page 50703 "Erpx CODIR Job"
{
    Caption = 'CODIR Job';
    PageType = List;
    SourceTable = Job;
    Editable = false;
    ShowFilter = true;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        Job: Record Job;
                    begin
                        Job.Reset();
                        Job.SetRange("No.", Rec."No.");
                        if Job.FindFirst() then
                            Page.Run(Page::"Erpx Job Card", Job);
                    end;
                }
                field(Abbreviation; Rec.Abbreviation)
                {
                    ApplicationArea = All;
                }
                field("Erpx Job City"; Rec."Erpx Job City")
                {
                    ApplicationArea = All;
                }
                field("ERPX Project Manager"; Rec."ERPX Project Manager")
                {
                    ApplicationArea = All;
                }
                field("Erpx % General Expenses Fees"; Rec."Erpx % General Expenses Fees")
                {
                    ApplicationArea = All;
                }
                field("Erpx % Desired Benefit"; Rec."Erpx % Desired Benefit")
                {
                    ApplicationArea = All;
                }
                field("Erpx Average Fees"; Rec."Erpx Average Fees")
                {
                    ApplicationArea = All;
                }
                field("Erpx No. of Orders"; Rec."Erpx No. of Orders")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Reset();
                        SalesHeader.SetRange("ErpX Job No.", Rec."No.");
                        Page.Run(Page::"Sales Order List", SalesHeader);
                    end;
                }
                field("Erpx Total amount of orders HT"; Rec."Erpx Total amount of orders HT")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    trigger OnDrillDown()
                    var
                        SalesHeader: Record "Sales Header";
                    begin
                        SalesHeader.Reset();
                        SalesHeader.SetRange("ErpX Job No.", Rec."No.");
                        Page.Run(Page::"Sales Order List", SalesHeader);
                    end;
                }
                field("Erpx Amount invoiced HT"; Rec."Erpx Amount invoiced HT")
                {
                    ApplicationArea = All;
                }
                field("Erpx % invoiced"; Rec."Erpx % invoiced")
                {
                    ApplicationArea = All;
                }
                field("Erpx Amount received HT"; Rec."Erpx Amount received HT")
                {
                    ApplicationArea = All;
                }
                field("Erpx Number of open invoices"; Rec."Erpx Number of open invoices")
                {
                    ApplicationArea = all;
                }
                field("Erpx Hourly Fees Available"; Rec."Erpx Hourly Fees Available")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Erpx Hourly Fees Used"; Rec."Erpx Hourly Fees Used")
                {
                    ApplicationArea = All;
                }
                field("Erpx % Hourly"; Rec."Erpx % Hourly")
                {
                    ApplicationArea = All;
                    StyleExpr = styleHour;
                }
                field("Erpx Hour fees Bal. Disposal"; Rec."Erpx Hour fees Bal. Disposal")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Erpx Planned hourly fees"; Rec."Erpx Planned hourly fees")
                {
                    ApplicationArea = All;
                }
                field("Erpx Fees HT at Disposal"; rec."Erpx Fees HT at Disposal")
                {
                    ApplicationArea = all;
                    Editable = false;
                }
                field("Erpx Fees HT Used"; Rec."Erpx Fees HT Used")
                {
                    ApplicationArea = All;
                }
                field("Erpx % Fees HT"; Rec."Erpx % Fees HT")
                {
                    ApplicationArea = All;
                    StyleExpr = styleFee;
                }
                field("Erpx Fees HT Balance Available"; Rec."Erpx Fees HT Balance Available")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Erpx Planned HT fees"; Rec."Erpx Planned HT fees")
                {
                    ApplicationArea = All;
                }

                field("Erpx Risk and Chance HT"; Rec."Erpx Risk and Chance HT")
                {
                    ApplicationArea = All;
                }

                field("Erpx Desired Benefit HT"; Rec."Erpx Desired Benefit HT")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Erpx Benefit Forecast"; Rec."Erpx Benefit Forecast")
                {
                    ApplicationArea = All;
                    Editable = false;
                }


            }
        }

    }
    actions
    {
        area(Processing)
        {
            action(Refresh)
            {
                Caption = 'Refresh';
                ApplicationArea = all;
                RunObject = report "Erpx update Statistque";
                Image = Recalculate;
                Promoted = true;
                PromotedCategory = Process;
            }
        }
        area(Reporting)
        {
            action(Print)
            {
                Caption = 'Print';
                ApplicationArea = all;
                RunObject = report "Erpx CODIR Job";
                Image = Print;
                Promoted = true;
                PromotedCategory = Report;
            }
        }
    }
    trigger OnOpenPage()
    var
        Job: Record Job;
    begin
        if Job.FindFirst() then
                repeat
                    Job.CalcSalesHeader(Job."No.");
                    Job.calcJob(Job."No.");
                until Job.Next() = 0;
        rec.setrange("Erpx Job Status", 'PROJET')
    end;

    trigger OnAfterGetRecord()
    begin
        styleFee := 'favorable';
        styleHour := 'favorable';
        styleforcast := 'Unfavorable';

        if Rec."Erpx % Fees HT" > 100 then
            styleFee := 'Unfavorable';
        if (Rec."Erpx % Fees HT" > 85) and (Rec."Erpx % Fees HT" < 100) then
            styleFee := 'ambiguous';

        if Rec."Erpx % Desired Benefit" > 100 then
            styleforcast := 'favorable';
        if (Rec."Erpx % Fees HT" > 85) and (Rec."Erpx % Fees HT" < 100) then
            styleforcast := 'ambiguous';

        if Rec."Erpx % Hourly" > 100 then
            styleHour := 'Unfavorable';
        if (Rec."Erpx % Fees HT" > 85) and (Rec."Erpx % Fees HT" < 100) then
            styleHour := 'ambiguous';
    end;

    var
        styleHour: Text;
        styleFee: Text;
        styleforcast: Text;
}
