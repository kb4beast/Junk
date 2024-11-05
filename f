// tool-details.component.ts
import { Component, OnInit } from '@angular/core';
import { ActivatedRoute } from '@angular/router';
import { FormBuilder, FormGroup, FormArray } from '@angular/forms';

interface ParameterDetails {
  key: number;
  paramType: string;
  length: string;
  inOrOut: string;
  isRequired: boolean;
  validValueList: string;
  name: string;
  value: string;
}

@Component({
  selector: 'app-tool-details',
  templateUrl: './tool-details.component.html',
  styleUrls: ['./tool-details.component.css']
})
export class ToolDetailsComponent implements OnInit {
  toolId: string;
  toolDetails: any;
  parameterForm: FormGroup;

  constructor(
    private route: ActivatedRoute,
    private fb: FormBuilder
  ) {
    this.parameterForm = this.fb.group({
      parameters: this.fb.array([])
    });
  }

  ngOnInit(): void {
    this.toolId = this.route.snapshot.paramMap.get('id'); // Get tool ID from route parameter
    this.getToolDetails();
  }

  getToolDetails(): void {
    // Mock tool details data (toolId is not mocked, taken from route)
    this.toolDetails = {
      id: this.toolId,
      name: 'Mock Tool Name',
      description: 'This is a mock tool description.',
      parameterDetails: [
        {
          key: 1,
          paramType: 'String',
          length: '50',
          inOrOut: 'In',
          isRequired: true,
          validValueList: 'Value1,Value2,Value3',
          name: 'Parameter Name 1',
          value: ''
        },
        {
          key: 2,
          paramType: 'Integer',
          length: '10',
          inOrOut: 'Out',
          isRequired: false,
          validValueList: '',
          name: 'Parameter Name 2',
          value: ''
        }
      ]
    };
    this.createParameterForm(this.toolDetails.parameterDetails);
  }

  createParameterForm(parameters: ParameterDetails[]): void {
    const parameterArray = this.parameterForm.get('parameters') as FormArray;
    parameters.forEach(param => {
      parameterArray.push(this.fb.group({
        name: [param.name],
        value: [param.value]
      }));
    });
  }

  get parameters(): FormArray {
    return this.parameterForm.get('parameters') as FormArray;
  }

  executeTool(): void {
    if (this.parameterForm.valid) {
      const toolExecutionDetails = {
        toolId: this.toolId,
        parameters: this.parameterForm.value.parameters
      };
      console.log('Mock Execution Details:', toolExecutionDetails);
      // Mock result handling
      console.log('Execution Result: Success');
    } else {
      console.error('Form is invalid');
    }
  }
}

// tool-details.component.html
<div *ngIf="toolDetails">
  <h2>{{ toolDetails.name }}</h2>
  <p>{{ toolDetails.description }}</p>

  <form [formGroup]="parameterForm">
    <div formArrayName="parameters" *ngFor="let parameter of parameters.controls; let i = index">
      <div [formGroupName]="i">
        <label>{{ parameter.get('name')?.value }}</label>
        <input type="text" formControlName="value">
      </div>
    </div>
    <button (click)="executeTool()">Execute</button>
  </form>
</div>
