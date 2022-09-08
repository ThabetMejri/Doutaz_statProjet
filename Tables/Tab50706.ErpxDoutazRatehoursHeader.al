table 50706 "Erpx Doutaz Rate hours Header"
{
    Caption = 'Doutaz Rate hours Header';
    DataClassification = ToBeClassified;

    fields
    {
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = ToBeClassified;
            TableRelation = Employee;
            trigger OnValidate()
            var
                SwSEmployee: Record "SwS Employee";
                SwsPayrollSetup: Record "SwS Payroll Setup";
                SwSWorkingCalendarLine: Record "SwS Working Calendar Line";
                StartDate: Date;
                EndDate: Date;
                RatehoursLine: Record "Erpx Doutaz Rate hours Line";
                CalcRatehours: Record "Erpx Doutaz Calc. Rate hours";
                AmountAVS: Decimal;
                SwSAllocatedSalary: Record "SwS Allocated Salary";
                Employee: Record Employee;
            begin
                if SwSEmployee.Get("Employee No.") then begin
                    AmountAVS := 0;
                    "Full Name" := SwSEmployee.Name + ' ' + SwSEmployee."First Name";
                    if SwsPayrollSetup.Get() then
                        "Maximum LA" := SwsPayrollSetup."UVG Maximum/Jahr";
                    "Employment %" := SwSEmployee."Employment %";
                    if CalcRatehours.Get(CalcRatehours.Code::"Nbre of Salary by year") then
                        "Nb of Salary by year" := CalcRatehours.Rate;
                    if CalcRatehours.Get(CalcRatehours.Code::"General costs") then
                        "General costs" := CalcRatehours.Rate;
                    Validate("Salary Amount Monthly", SwSEmployee."Salary Amount");
                    StartDate := DMY2Date(1, 1, Date2DMY(Today, 3));
                    EndDate := DMY2Date(31, 12, Date2DMY(Today, 3));

                    SwSWorkingCalendarLine.Reset();
                    SwSWorkingCalendarLine.SetRange(Group, SwSEmployee."Working Group");
                    SwSWorkingCalendarLine.SetRange("Day Type", 'A');
                    SwSWorkingCalendarLine.SetRange(Date, StartDate, EndDate);
                    if SwSWorkingCalendarLine.FindSet() then begin
                        SwSWorkingCalendarLine.CalcSums(Hours);
                        "Annual number of hours" := SwSWorkingCalendarLine.Hours;
                    end
                    else
                        "Annual number of hours" := 0;
                    RatehoursLine.Reset();
                    RatehoursLine.SetRange("Employee No.", Rec."Employee No.");
                    if RatehoursLine.FindFirst() then
                        RatehoursLine.DeleteAll();
                    CalcRatehours.Reset();
                    CalcRatehours.SetFilter(Code, '<9');
                    if CalcRatehours.FindFirst() then
                        repeat
                            RatehoursLine.Init();
                            RatehoursLine."Employee No." := rec."Employee No.";
                            RatehoursLine.Validate(RatehoursLine.Code, CalcRatehours.Code);
                            RatehoursLine.Validate(Rate, CalcRatehours.Rate);
                            if (RatehoursLine.Code = RatehoursLine.Code::"AVS/AI/APG") or (RatehoursLine.Code = RatehoursLine.Code::IJM) or (RatehoursLine.Code = RatehoursLine.Code::"Caisse AF") then
                                RatehoursLine.validate(RatehoursLine."Base Amount", Rec."Salary Amount Annually");
                            if (RatehoursLine.Code = RatehoursLine.Code::AC) or (RatehoursLine.Code = RatehoursLine.Code::LAA) then
                                RatehoursLine.validate("Base Amount", Rec."Salary Amount Annually LAA");
                            if (RatehoursLine.Code = RatehoursLine.Code::"AC Comp") or (RatehoursLine.Code = RatehoursLine.Code::"LAA Comp") then
                                RatehoursLine.validate("Base Amount", Rec."Salary Amount Annually LAA/C");
                            if (RatehoursLine.Code = RatehoursLine.Code::"AVS/AI/APG") then
                                AmountAVS := RatehoursLine.Amount;
                            if (RatehoursLine.Code = RatehoursLine.Code::"Frais de gestion") then
                                RatehoursLine.Validate("Base Amount", AmountAVS);
                            if (RatehoursLine.Code = RatehoursLine.Code::LPP) then begin
                                SwSAllocatedSalary.Reset();
                                SwSAllocatedSalary.SetRange("Employee No.", "Employee No.");
                                SwSAllocatedSalary.SetRange("Salary Type No.", '6240');
                                if SwSAllocatedSalary.FindFirst() then begin
                                    if Employee.Get("Employee No.") and (Employee."Erpx % LPP employee" <> 0) then
                                        RatehoursLine.Validate("Base Amount", -(SwSAllocatedSalary.Amount/(Employee."Erpx % LPP employee"/100)*(1-Employee."Erpx % LPP employee"/100))*Rec."Nb of Salary by year");
                                end;
                            end;
                            RatehoursLine.Insert(true);
                        until CalcRatehours.Next() = 0;
                end
                else begin
                    "Full Name" := '';
                    Validate("Salary Amount Monthly", 0);
                end;

            end;
        }
        field(3; "Full Name"; Text[250])
        {
            Caption = 'Full Name';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "Salary Amount Monthly"; decimal)
        {
            Caption = 'Salary Amount Monthly';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                "Salary Amount Annually" := "Salary Amount Monthly" * "Employment %" / 100 * "Nb of Salary by year";
                "Salary Amount Annually LAA/C" := 0;
                "Salary Amount Annually LAA" := 0;
                if "Salary Amount Annually" <= "Maximum LA" then
                    "Salary Amount Annually LAA" := "Salary Amount Annually"
                else begin
                    "Salary Amount Annually LAA" := "Maximum LA";
                    "Salary Amount Annually LAA/C" := "Salary Amount Annually" - "Maximum LA";
                end;

            end;

        }
        field(5; "Employment %"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Employment %';

        }
        field(6; "Salary Amount Annually"; decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Salary Amount Annually';
        }
        field(7; "Nb of Salary by year"; decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Nb of Salary by year';
            InitValue = 13;
        }
        field(8; "Maximum LA"; Decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Maximum LA';
            Editable = false;
        }
        field(9; "Salary Amount Annually LAA"; decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
            Caption = 'Salary Amount Annually LAA';
        }
        field(10; "Salary Amount Annually LAA/C"; decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Salary Amount Annually LAA/C';
            Editable = false;
        }
        field(11; "Total annual social charges"; decimal)
        {
            Caption = 'Total annual social charges';
            FieldClass = FlowField;
            CalcFormula = sum("Erpx Doutaz Rate hours Line".Amount where("Employee No." = field("Employee No.")));
            Editable = false;
        }
        field(12; "Total annual employer charges"; decimal)
        {
            Caption = 'Total annual employer charges';
            DataClassification = ToBeClassified;
            Editable = false;
            trigger OnValidate()
            begin
                if "Annual number of hours" <> 0 then
                    "Net hourly rate without FG" := "Total annual employer charges" / "Annual number of hours"
                else
                    "Net hourly rate without FG" := 0;
                "Net hourly rate with FG" := Round("Net hourly rate without FG" * (1 + "General costs" / 100), 0.01, '>');
                if Resource.Get(Rec."Employee No.") then begin
                    Resource.Validate("Unit Cost", rec."Net hourly rate with FG");
                    Resource.Modify();
                end;
            end;
        }

        field(13; "Annual number of hours"; Decimal)
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(14; "General costs"; Decimal)
        {
            Caption = 'General costs';
            Editable = false;
        }
        field(15; "Net hourly rate without FG"; decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Net hourly rate without FG';
            Editable = false;
        }
        field(16; "Net hourly rate with FG"; decimal)
        {
            DataClassification = ToBeClassified;
            Caption = 'Net hourly rate with FG';
            Editable = false;
        }



    }
    keys
    {
        key(PK; "Employee No.")
        {
            Clustered = true;
        }
    }
    trigger OnDelete()
    begin
        RatehoursLine.Reset();
        RatehoursLine.SetRange("Employee No.", "Employee No.");
        if RatehoursLine.FindFirst() then
            RatehoursLine.DeleteAll();
    end;

    var
        RatehoursLine: Record "Erpx Doutaz Rate hours Line";
        Resource: Record Resource;
}
