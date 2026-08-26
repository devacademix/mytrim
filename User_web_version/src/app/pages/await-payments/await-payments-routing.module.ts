import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AwaitPaymentsComponent } from './await-payments.component';

const routes: Routes = [
  {
    path: '',
    component: AwaitPaymentsComponent
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule]
})
export class AwaitPaymentsRoutingModule { }
