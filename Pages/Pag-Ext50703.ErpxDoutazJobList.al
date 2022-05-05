pageextension 50703 "Erpx Doutaz Job List" extends "Erpx Job List"
{
    actions
    {
        addafter(JobLedgerEntries)
        {
            action(CODIR)
            {
                ApplicationArea = all;
                Caption = 'JOB CODIR';
                RunObject = page "Erpx CODIR Job";
                Image = Statistics;
                Promoted = true;
                PromotedCategory = Category6;
            }
        }
    }
}
