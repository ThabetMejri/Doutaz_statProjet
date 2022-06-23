pageextension 50700 "ErpxDoutazJobCard" extends "Erpx Job Card"
{


    layout
    {
        addafter(Comment)
        {

            field("Erpx % General Expenses Fees"; Rec."Erpx % General Expenses Fees")
            {
                ApplicationArea = All;
                trigger OnAssistEdit()
                var
                    JobProgress: Record "Erpx Doutaz Job Progress";
                begin
                    JobProgress.Reset();
                    JobProgress.SetRange("Job No.", Rec."No.");
                    Page.Run(Page::ErpxDoutazJobProgress, JobProgress)
                end;
            }
            field("Erpx % Desired Benefit "; Rec."Erpx % Desired Benefit")
            {
                ApplicationArea = All;
            }
            field("Erpx Average Fees"; Rec."Erpx Average Fees")
            {
                ApplicationArea = All;
            }
        }
        addafter(Customer)
        {
            group("Erpx Honorary statistics")
            {
                Caption = 'Honorary Statistics';
                field("Erpx Fee Amount HT"; Rec."Erpx Fee Amount HT")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    DrillDownPageId = "Sales Order List";
                    Importance = Additional;
                }
                field("Erpx Overheads Desired Profit"; Rec."Erpx Overheads Desired Profit")
                {
                    ApplicationArea = All;
                    DrillDown = true;
                    DrillDownPageId = "Sales Order List";
                    Importance = Additional;
                }
                group(FeesHT)
                {
                    Caption = 'Fees HT';

                    field("Erpx Fees HT at Disposal"; rec."Erpx Fees HT at Disposal")
                    {
                        ApplicationArea = all;
                        Editable = false;
                    }
                    field("Erpx Fees HT Used"; Rec."Erpx Fees HT Used")
                    {
                        ApplicationArea = All;
                    }
                    field("Erpx Fees HT Balance Available"; Rec."Erpx Fees HT Balance Available")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
                group(HourlyFees)
                {
                    Caption = 'Hourly Fees';

                    field("Erpx Hourly Fees Available"; Rec."Erpx Hourly Fees Available")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                    field("Erpx Hourly Fees Used"; Rec."Erpx Hourly Fees Used")
                    {
                        ApplicationArea = All;

                    }
                    field("Erpx Hour fees Bal. Disposal"; Rec."Erpx Hour fees Bal. Disposal")
                    {
                        ApplicationArea = All;
                        Editable = false;
                    }
                }
            }
            group("Statistics Planning HT")
            {
                Caption = 'Statistics Planning HT';
                field("Erpx Planned HT fees"; rec."Erpx Planned HT fees")
                {
                    ApplicationArea = all;
                }

                field("Erpx Planned hourly fees"; rec."Erpx Planned hourly fees")
                {
                    ApplicationArea = All;
                }
            }
            group("Erpx End statistics of construction")
            {
                Caption = 'End statistics of construction';
                field("Erpx Desired Benefit HT"; Rec."Erpx Desired Benefit HT")
                {
                    ApplicationArea = All;
                    Editable = false;
                }

                field("Erpx Risk and Chance HT"; Rec."Erpx Risk and Chance HT")
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
        addafter(JobLedgerEntries)
        {
            action(CalcStat)
            {
                Caption = 'Calculer statistique';
                ApplicationArea = all;
                Image = CalculateRemainingUsage;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Category6;
                trigger OnAction()
                begin
                    rec.CalcSalesHeader(rec."No.");
                    Rec.calcJob(Rec."No.");
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        if Rec."No." <> '' then begin
            rec.CalcSalesHeader(rec."No.");
            Rec.calcJob(Rec."No.");
        end;
    end;

}
