Rake.application.instance_variable_get('@tasks').delete('db:test:prepare')

namespace 'db' do
  namespace 'test' do
      task 'prepare' do
      end
  end
end

