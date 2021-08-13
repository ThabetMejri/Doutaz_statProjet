pageextension 50700 ErpxDoutazJobCard extends "Erpx Job Card"
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
                    JobProgress: Record ErpxDoutazJobProgress;
                begin
                    JobProgress.Reset();
                    JobProgress.SetRange("Job No.", Rec."No.");
                    Page.Run(Page::ErpxDoutazJobProgress, JobProgress);
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
                PromotedCategory = Category6;
                trigger OnAction()
                var
                    salesHeader: Record "Sales Header";
                    job: Record Job;
                    DetailContrat: Record "Erpx Contract Detail";
                begin
                    job.Get(Rec."No.");
                    salesHeader.Reset();
                    salesHeader.SetRange("ErpX Job No.", job."No.");
                    salesHeader.SetRange("Erpx FA Statistics", true);
                    salesHeader.SetFilter("Erpx Document Type", '%1|%2|%3|%4|%5|%6', salesHeader."Erpx Document Type"::"Contract Hours", salesHeader."Erpx Document Type"::"Contract Payment plan",
                                        salesHeader."Erpx Document Type"::"Hours amendment", salesHeader."Erpx Document Type"::"Payment plan amendment", salesHeader."Erpx Document Type"::"Progress contract",
                                        salesHeader."Erpx Document Type"::"Advancement amendment");
                    if salesHeader.FindFirst() then begin
                        repeat
                            if (salesHeader."Erpx Document Type" = salesHeader."Erpx Document Type"::"Contract Hours") or (salesHeader."Erpx Document Type" = salesHeader."Erpx Document Type"::"Hours amendment") then begin
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
                            salesHeader.CalcFields("Erpx Other Fees");
                            salesHeader."Erpx Fee Amount HT" := salesHeader."Erpx Total Amount HT" - salesHeader."Erpx Other Fees";
                            job.CalcFields("Erpx % General Expenses Fees");
                            salesHeader."Erpx Overheads Desired Profit" := salesHeader."Erpx Fee Amount HT" * (job."Erpx % General Expenses Fees" + job."Erpx % Desired Benefit") / 100;
                            salesHeader.Modify();
                            job."Erpx Fee Amount HT" += salesHeader."Erpx Fee Amount HT";
                        until salesHeader.Next() = 0;

                    end;
                    job.CalcFields("Erpx Fee Amount HT", "Erpx Overheads Desired Profit");
                    job."Erpx Fees HT at Disposal" := job."Erpx Fee Amount HT" - job."Erpx Overheads Desired Profit";
                    job."Erpx Fees HT Balance Available" := job."Erpx Fees HT at Disposal" - job."Erpx Fees HT Used";
                    if job."Erpx Average Fees" <> 0 then
                        job."Erpx Hourly Fees Available" := job."Erpx Fees HT at Disposal" / job."Erpx Average Fees"
                    else
                        job."Erpx Hourly Fees Available" := 0;
                    job."Erpx Hour fees Bal. Disposal" := job."Erpx Hourly Fees Available" - job."Erpx Hourly Fees Used";
                    job."Erpx Desired Benefit HT" := job."Erpx Fee Amount HT" * job."Erpx % Desired Benefit" / 100;
                    job."Erpx Benefit Forecast" := job."Erpx Desired Benefit HT" + job."Erpx Risk and Chance HT";
                    job."Erpx Risk and Chance HT" := job."Erpx Fees HT at Disposal";
                    job.Modify();
                end;
            }
        }
    }
}
